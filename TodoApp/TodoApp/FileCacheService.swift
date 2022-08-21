// Created for YandexMobileSchool in 2022
// by Murphy
// Using Swift 5.0
// Running on macOS 12.5

import Foundation

protocol FileCacheServiceProtocol {
    
    func save(to file: String, todoItems: [String: TodoItem], completion: @escaping (Result<Void, Error>) -> Void)
    
    func load(from file: String, completion: @escaping (Result<[String: TodoItem], Error>) -> Void)
    
}

enum FileCacheError: Error {
    case gettingDirectoryError
    case serializationError
    case incorrectData
}
struct Constants {
    static let testFile = "testTodoInput3.json"
}

class FileCacheService: FileCacheServiceProtocol {
    
    private let queue = DispatchQueue(label: "fileCacheServiceQueue")
    
    func save(to file: String = Constants.testFile,
              todoItems: [String: TodoItem],
              
              completion: @escaping (Result<Void, Error>) -> Void) {
        queue.async {
            guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return
            }
            let fileURL = documentDirectory.appendingPathComponent(file)
            var jsonArray: [Any] = []
            for todoItem in todoItems.values {
                let item = todoItem.json
                jsonArray.append(item)
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: jsonArray)
                try jsonData.write(to: fileURL)
                Logger.log("Files were successfully written to drive")
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(FileCacheError.serializationError))
                }
            }
        }
    }
    
    func load(from file: String = Constants.testFile, completion: @escaping (Result<[String: TodoItem], Error>) -> Void) {
        queue.sync {
            guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                completion(.failure(FileCacheError.gettingDirectoryError))
                return
            }
            let fileURL = documentDirectory.appendingPathComponent(file)
            var data: Data?
            do {
                data = try Data(contentsOf: fileURL)
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(FileCacheError.incorrectData))
                }
            }
            guard let correctData = data else { return }
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: correctData) as? [Any] {
                    var toDoItems: [String: TodoItem] = [:]
                    for item in jsonArray {
                        guard let toDoItem = TodoItem.parse(json: item) else { continue }
                        toDoItems[toDoItem.id] = toDoItem
                    }
                    Logger.log("Successful files receiving from drive")
                    DispatchQueue.main.async {
                        completion(.success(toDoItems))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(FileCacheError.serializationError))
                }
            }
        }
    }
}
