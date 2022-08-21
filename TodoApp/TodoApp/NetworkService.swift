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
    
    func editTodoItem(at id: String, completion: @escaping (Result<String, Error>) -> Void)
    
    func deleteTodoItem(at id: String, completion: @escaping (Result<String, Error>) -> Void)
}

enum NetworkError: Error {
    case failedRequest
    case failedToGetItem
}

final class NetworkService: NetworkServiceProtocol {
    
    private let queue = DispatchQueue(label: "networkServiceQueue")

    func getAllTodoItems(completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        queue.async {
            guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
            let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
                guard let data = data, !data.isEmpty, error == nil else { return }
                do {
                    Logger.log("Successful files receiving from network")
                    DispatchQueue.main.async {
                        completion(.success([TodoItem(text: "network:1"),
                                             TodoItem(text: "network:2"),
                                             TodoItem(text: "network:3"),
                                             TodoItem(text: "network:4"),
                                             TodoItem(text: "network:5")]))
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
    
    func deleteTodoItem(at id: String, completion: @escaping (Result<String, Error>) -> Void) {
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
}
