// Created for YandexMobileSchool in 2022
// by Murphy
// Using Swift 5.0
// Running on macOS 12.5

import Foundation
let userDefaults = UserDefaults.standard

protocol NetworkServiceProtocol {
    
    func getAllTodoItems(completion: @escaping (Result<[TodoItem], Error>) -> Void)
    
    func uploadTodoItem(todoItem: TodoItem, completion: @escaping (Result<Void, Error>) -> Void)
    
    func editTodoItem(at id: String, completion: @escaping (Result<String, Error>) -> Void)
    
    func deleteTodoItem(at id: String, completion: @escaping (Result<Void, Error>) -> Void)
}

enum NetworkError: Error {
    case failedRequest
    case noInternet
}

class NetworkConstants {
    
     static let token = "HandbookOfProjections"
     static let url = "https://beta.mrdekk.ru/todobackend/list"
     static var revision: Int = userDefaults.integer(forKey: "revision") {
        didSet {
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
    
    private var createRequest: URLRequest {
         let url = URL(string: NetworkConstants.url)!
        var request = URLRequest(url: url)
        request.setValue("\(NetworkConstants.revision)", forHTTPHeaderField: "X-Last-Known-Revision")
        request.setValue("Bearer \(NetworkConstants.token)", forHTTPHeaderField: "Authorization")
    }
    
    private let queue = DispatchQueue(label: "ru.murphy.todoapp.networkServiceQueue")
    
    // MARK: - Network methods
    
    func getRevision() -> Int {
        queue.sync {
        let task = session.dataTask(with: createRequest) { data, response, error in
            guard let data = data, !data.isEmpty, error == nil else { return }
            
                guard let jsonArray = try JSONSerialization.jsonObject(with: data) as? [String: Any] else { return nil }
                return jsonArray["revision"]
                
            
        }
        task.resume()
        }
    }

    // MARK: - Get
    func getAllTodoItems(completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        queue.sync {
            let request = createRequest
            let task = session.dataTask(with: request) { data, response, error in
                guard let data = data, !data.isEmpty, error == nil else { return }
                do {
                    Logger.log("Successful GET")
                    if let jsonArray = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        guard let items = jsonArray["list"] as? [Any] else { return }
                        var todoItems: [TodoItem] = []
                        for item in items {
                            guard let toDoItem = TodoItem.parse(json: item) else { continue }
                            todoItems.append(toDoItem)
                        }
                        DispatchQueue.main.async {
                            completion(.success(todoItems))
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(FileCacheError.serializationError))
                    }
                }
                
            }
            task.resume()
        }
    }
    
    func createPatch(with todoItems: [TodoItem], delay: Double = 0, completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        queue.asyncAfter(deadline: .now() + delay) { [self] in
            
            
            let token = constants.token
            guard let url = URL(string: constants.url) else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.failedRequest))
                }
                return 
            }
            
            var request = URLRequest(url: url)
           
            
            var jsonArray: [Any] = []
            for item in todoItems {
                jsonArray.append(item.jsonToNetwork)
            }
            var jsonDict: [String: Any] = [:]
            jsonDict["list"] = jsonArray
            let body = try? JSONSerialization.data(withJSONObject: jsonDict)
            request.httpMethod = "PATCH"
            request.httpBody = body
            request.timeoutInterval = 3
            request.setValue("\(constants.revision)", forHTTPHeaderField: "X-Last-Known-Revision")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.failedRequest))
                    }
                    return
                }
                guard let data = data, !data.isEmpty else { return }
                do {
                    Logger.log("Successful files receiving from network")
                    if let jsonArray = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        guard let items = jsonArray["list"] as? [Any] else { return }
                        var todoItems: [TodoItem] = []
                        for item in items {
                            guard let toDoItem = TodoItem.parse(json: item) else { continue }
                            todoItems.append(toDoItem)
                        }
                        DispatchQueue.main.async {
                            completion(.success(todoItems))
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(FileCacheError.serializationError))
                    }
                }
                
            }
            task.resume()
        }
    }
    
    func getTodoItem(at id: String, completion: @escaping (Result<TodoItem, Error>) -> Void) {
        queue.async {
            let token = self.constants.token
            guard let url = URL(string: self.constants.url + "/\(id)") else { return }
            var request = URLRequest(url: url)
            
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, !data.isEmpty, error == nil else { return }
                do {
                    Logger.log("Successful item receiving from network")
                    if let jsonArray = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        guard let item = jsonArray["element"] as? [String: Any] else { return }
                        
                        guard let todoItem = TodoItem.parse(json: item) else { return }
                        
                        DispatchQueue.main.async {
                            completion(.success(todoItem))
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(FileCacheError.serializationError))
                    }
                }
                
            }
            task.resume()
        }
        
    }
    
    func uploadTodoItem(todoItem: TodoItem, completion: @escaping (Result<Void, Error>) -> Void) {
        queue.async { [self] in
            
            var jsonDict: [String: Any] = [:]
            let json = todoItem.jsonToNetwork
            jsonDict["element"] = json
            let body = try? JSONSerialization.data(withJSONObject: jsonDict)
            
            let token = constants.token
            guard let url = URL(string: constants.url) else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = body
            request.timeoutInterval = 3
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("\(constants.revision)", forHTTPHeaderField: "X-Last-Known-Revision")
            let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.failedRequest))
                    }
                    return
                }
                
                guard let data = data, !data.isEmpty else { return }
                do {
                    if let jsonArray = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        
                        constants.revision = jsonArray["revision"] as? Int ?? 0
                    } else { completion(.failure(error!)) }
                    DispatchQueue.main.async {
                        completion(.success(()))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.failedRequest))
                    }
                }
            }
            task.resume()
        }
    }
    
    func editTodoItem(at id: String, completion: @escaping (Result<String, Error>) -> Void) {
        queue.asyncAfter(deadline: .now() + 1) {
            DispatchQueue.main.async {
                if Bool.random() {
                    completion(.success(""))
                } else {
                    completion(.failure(NetworkError.noInternet))
                }
            }
        }
    }
   
    func deleteTodoItem(at id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        queue.async { [self] in
            
            let body = Data()
            let token = constants.token
            guard let url = URL(string: constants.url + "/\(id)") else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.httpBody = body
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("\(constants.revision)", forHTTPHeaderField: "X-Last-Known-Revision")
            let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
                guard let data = data, !data.isEmpty, error == nil else { return }
                do {
                    if let jsonArray = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        
                        constants.revision = jsonArray["revision"] as? Int ?? 0
                    } else { completion(.failure(error!)) }
                    DispatchQueue.main.async {
                        completion(.success(()))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.failedRequest))
                    }
                }
            }
            task.resume()
        }
    }
    
}

