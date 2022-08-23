// Created for YandexMobileSchool in 2022
// by Murphy
// Using Swift 5.0
// Running on macOS 12.5

import Foundation
let userDefaults = UserDefaults.standard

protocol NetworkServiceProtocol {
    
    func getAllTodoItems(completion: @escaping (Result<[TodoItem], Error>) -> Void)
    
    func createPatch(with todoItems: [TodoItem], delay: Double, completion: @escaping (Result<[TodoItem], Error>) -> Void)
    
    func uploadTodoItem(todoItem: TodoItem, completion: @escaping (Result<Void, Error>) -> Void)
    
    func deleteTodoItem(at id: String, completion: @escaping (Result<Void, Error>) -> Void)
}

enum NetworkError: Error {
    case failedRequest
    case noInternet
    case serializationError
}

class NetworkConstants {
    
    static let token = "HandbookOfProjections"
    static let url = "https://beta.mrdekk.ru/todobackend/list"
    static var revision: Int = userDefaults.integer(forKey: "revision") {
        didSet {
            Logger.log("Current revision: \(revision)")
            userDefaults.set(revision, forKey: "revision")
        }
    }
}


final class NetworkService: NetworkServiceProtocol {
    
    // MARK: - Private properties
    
    private var session: URLSession = {
        let session = URLSession(configuration: .default)
        session.configuration.timeoutIntervalForRequest = 42
        return session
        
    }()
    
    private var createRequest: URLRequest? {
        let url = URL(string: NetworkConstants.url)!
        var request: URLRequest? = URLRequest(url: url)
        if NetworkConstants.revision == 0 {
            getRevision(completion: { result in
                switch result {
                case .success(let revision):
                    NetworkConstants.revision = revision
                case .failure:
                    request = nil
                }
            })
        }
        if request != nil {
            request!.setValue("\(NetworkConstants.revision)", forHTTPHeaderField: "X-Last-Known-Revision")
            request!.setValue("Bearer \(NetworkConstants.token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
    
    private let queue = DispatchQueue(label: "ru.murphy.todoapp.networkServiceQueue")
    
    // MARK: - Network methods
    
    func getRevision(completion: @escaping (Result<Int, Error>) -> Void) {
        queue.sync {
            guard let request = createRequest else {
                completion(.failure(NetworkError.failedRequest))
                return
            }
            let task = session.dataTask(with: request) { data, response, error in
                if error != nil {
                    completion(.failure(NetworkError.noInternet))
                    return
                }
                guard let data = data, !data.isEmpty else {
                    completion(.failure(NetworkError.failedRequest))
                    return
                }
                
                if let jsonArray = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let revision = jsonArray["revision"] as? Int {
                    completion(.success(revision)) } else { completion(.failure(NetworkError.serializationError)) }
            }
            task.resume()
        }
    }
    
    // MARK: - Get
    
    func getAllTodoItems(completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        queue.sync {
            guard var request = createRequest else {
                completion(.failure(NetworkError.failedRequest))
                return
            }
            request.httpMethod = "GET"
            let task = session.dataTask(with: request) { data, response, error in
                if error != nil {
                    DispatchQueue.main.async { completion(.failure(NetworkError.noInternet)) }
                    return
                }
                guard let data = data, !data.isEmpty else {
                    DispatchQueue.main.async { completion(.failure(NetworkError.failedRequest)) }
                    return
                }
                
                Logger.log("Successful GET")
                if let jsonArray = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let items = jsonArray["list"] as? [Any],
                   let revision = jsonArray["revision"] as? Int {
                    NetworkConstants.revision = revision
                    var todoItems: [TodoItem] = []
                    for item in items {
                        guard let toDoItem = TodoItem.parse(json: item) else { continue }
                        todoItems.append(toDoItem)
                    }
                    DispatchQueue.main.async { completion(.success(todoItems)) }
                } else {
                    DispatchQueue.main.async { completion(.failure(NetworkError.serializationError)) }
                }
            }
            task.resume()
        }
    }
    
    // MARK: - PATCH
    
    func createPatch(with todoItems: [TodoItem], delay: Double = 0, completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        queue.asyncAfter(deadline: .now() + delay) { [self] in
            guard var request = createRequest else {
                completion(.failure(NetworkError.failedRequest))
                return
            }
            request.httpMethod = "PATCH"
            var jsonArray: [Any] = []
            for item in todoItems {
                jsonArray.append(item.jsonToNetwork)
            }
            var jsonDict: [String: Any] = [:]
            jsonDict["list"] = jsonArray
            let body = try? JSONSerialization.data(withJSONObject: jsonDict)
            request.httpBody = body
            let task = session.dataTask(with: request) { data, response, error in
                if error != nil {
                    DispatchQueue.main.async { completion(.failure(NetworkError.noInternet)) }
                    return
                }
                guard let data = data, !data.isEmpty else {
                    DispatchQueue.main.async { completion(.failure(NetworkError.failedRequest)) }
                    return
                }
                
                Logger.log("Successful PATCH")
                if let jsonArray = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let items = jsonArray["list"] as? [Any],
                   let revision = jsonArray["revision"] as? Int {
                    NetworkConstants.revision = revision
                    var todoItems: [TodoItem] = []
                    for item in items {
                        guard let toDoItem = TodoItem.parse(json: item) else { continue }
                        todoItems.append(toDoItem)
                    }
                    DispatchQueue.main.async { completion(.success(todoItems)) }
                } else {
                    DispatchQueue.main.async { completion(.failure(NetworkError.serializationError)) }
                }
            }
            task.resume()
        }
    }
    
    // MARK: - GET ITEM
    
    func getTodoItem(at id: String, completion: @escaping (Result<TodoItem, Error>) -> Void) {
        queue.async { [self] in
            guard var request = createRequest else {
                completion(.failure(NetworkError.failedRequest))
                return
            }
            request.httpMethod = "GET"
            request.url = URL(string: NetworkConstants.url + "/\(id)")!
            let task = session.dataTask(with: request) { data, response, error in
                if error != nil {
                    DispatchQueue.main.async { completion(.failure(NetworkError.noInternet)) }
                    return
                }
                guard let data = data, !data.isEmpty else {
                    DispatchQueue.main.async { completion(.failure(NetworkError.failedRequest)) }
                    return
                }
                
                Logger.log("Successful: GET ITEM")
                if let jsonArray = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let item = jsonArray["element"] as? [String: Any],
                   let todoItem = TodoItem.parse(json: item),
                   let revision = jsonArray["revision"] as? Int {
                    NetworkConstants.revision = revision
                    DispatchQueue.main.async { completion(.success(todoItem)) }} else {
                        DispatchQueue.main.async { completion(.failure(NetworkError.serializationError)) }
                    }
            }
            task.resume()
        }
    }
    
    // MARK: - POST ITEM
    
    func uploadTodoItem(todoItem: TodoItem, completion: @escaping (Result<Void, Error>) -> Void) {
        queue.async { [self] in
            guard var request = createRequest else {
                completion(.failure(NetworkError.failedRequest))
                return
            }
            request.httpMethod = "POST"
            var jsonDict: [String: Any] = [:]
            let json = todoItem.jsonToNetwork
            jsonDict["element"] = json
            let body = try? JSONSerialization.data(withJSONObject: jsonDict)
            request.httpBody = body
            request.url = URL(string: NetworkConstants.url + "/\(todoItem.id)")!
            let task = session.dataTask(with: request) { data, response, error in
                if error != nil {
                    DispatchQueue.main.async { completion(.failure(NetworkError.noInternet)) }
                    return
                }
                guard let data = data, !data.isEmpty else {
                    DispatchQueue.main.async { completion(.failure(NetworkError.failedRequest)) }
                    return
                }
                
                Logger.log("Successful: POST ITEM")
                if let jsonArray = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let revision = jsonArray["revision"] as? Int {
                    NetworkConstants.revision = revision
                    DispatchQueue.main.async { completion(.success(())) }} else {
                        DispatchQueue.main.async { completion(.failure(NetworkError.serializationError)) }
                    }
            }
            task.resume()
        }
    }
    
    // MARK: - DELETE ITEM
    
    func deleteTodoItem(at id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        queue.async { [self] in
            guard var request = createRequest else {
                completion(.failure(NetworkError.failedRequest))
                return
            }
            request.httpMethod = "DELETE"
            request.url = URL(string: NetworkConstants.url + "/\(id)")!
            let task = session.dataTask(with: request) { data, response, error in
                if error != nil {
                    DispatchQueue.main.async { completion(.failure(NetworkError.noInternet)) }
                    return
                }
                guard let data = data, !data.isEmpty else {
                    DispatchQueue.main.async { completion(.failure(NetworkError.failedRequest)) }
                    return
                }
                
                Logger.log("Successful: DELETE ITEM")
                if let jsonArray = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let revision = jsonArray["revision"] as? Int {
                    NetworkConstants.revision = revision
                    DispatchQueue.main.async { completion(.success(())) }} else {
                        DispatchQueue.main.async { completion(.failure(NetworkError.serializationError)) }
                    }
            }
            task.resume()
        }
    }
}
