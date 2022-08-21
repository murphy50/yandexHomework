// Created for YandexMobileSchool in 2022
// by Murphy
// Using Swift 5.0
// Running on macOS 12.5

import Foundation

func currentQueueName() -> String? {
    let name = __dispatch_queue_get_label(nil)
    return String(cString: name, encoding: .utf8)
}
protocol NetworkServiceProtocol {
    
    func getAllTodoItems(completion: @escaping (Result<[TodoItem], Error>) -> Void)
    
    func uploadTodoItem(todoItem: TodoItem, completion: @escaping (Result<Void, Error>) -> Void)
    
    func editTodoItem(at id: String, completion: @escaping (Result<String, Error>) -> Void)
    
    func deleteTodoItem(at id: String, completion: @escaping (Result<Void, Error>) -> Void)
}

enum NetworkError: Error {
    case failedRequest
    case failedToGetItem
}

struct NetworkConstants {
    static let token = "HandbookOfProjections"
    static let url = "https://beta.mrdekk.ru/todobackend/list"
    static var revision: Int = 130
}

final class NetworkService: NetworkServiceProtocol {
    
    private let queue = DispatchQueue(label: "networkServiceQueue")
    
    func getAllTodoItems(completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        queue.sync {
            let token = NetworkConstants.token
            guard let url = URL(string: NetworkConstants.url) else { return }
            var request = URLRequest(url: url)
            request.setValue("110", forHTTPHeaderField: "X-Last-Known-Revision")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, !data.isEmpty, error == nil else { return }
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
            let token = NetworkConstants.token
            guard let url = URL(string: NetworkConstants.url + "/\(id)") else { return }
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
        queue.async {
            
            var jsonDict: [String: Any] = [:]
            let json = todoItem.jsonToNetwork
            jsonDict["element"] = json
            let body = try? JSONSerialization.data(withJSONObject: jsonDict)
            
            let token = NetworkConstants.token
            guard let url = URL(string: NetworkConstants.url) else { return }
            print(jsonDict)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = body
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("\(NetworkConstants.revision)", forHTTPHeaderField: "X-Last-Known-Revision")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, !data.isEmpty, error == nil else { return }
                do {
                    if let jsonArray = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        
                        NetworkConstants.revision = jsonArray["revision"] as? Int ?? 0
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
                    completion(.failure(NetworkError.failedToGetItem))
                }
            }
        }
    }
   
    func deleteTodoItem(at id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        queue.async {
            
            let body = Data()
            let token = NetworkConstants.token
            guard let url = URL(string: NetworkConstants.url + "/\(id)") else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.httpBody = body
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("\(NetworkConstants.revision)", forHTTPHeaderField: "X-Last-Known-Revision")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, !data.isEmpty, error == nil else { return }
                do {
                    if let jsonArray = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        
                        NetworkConstants.revision = jsonArray["revision"] as? Int ?? 0
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

