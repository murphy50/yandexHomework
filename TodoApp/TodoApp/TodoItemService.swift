// Created for YandexMobileSchool in 2022
// by Murphy
// Using Swift 5.0
// Running on macOS 12.5

import Foundation

protocol TodoItemServiceDelegate: AnyObject {
    func updateTodoItems()
}

final class TodoItemService {
    
    private var fileCache: FileCacheService
    private var network: NetworkService
    weak var delegate: TodoItemServiceDelegate?
    private(set) var todoItems: [String: TodoItem] = [:] {
        didSet {
            delegate?.updateTodoItems()
            saveToDrive()
        }
    }
    
    init(_ fileCache: FileCacheService, _ network: NetworkService) {
        self.fileCache = fileCache
        self.network = network
    }
    
    func load() {
        fileCache.load { result in
            switch result {
            case .success(let todoItems):
                print("hello")
                // self.todoItems = todoItems
            case .failure:
                self.network.getAllTodoItems { result in
                    switch result {
                    case .success(let todoItems):
                        for item in todoItems {
                            self.add(item)
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func saveToDrive() {
        fileCache.save(todoItems: todoItems) { result in
            switch result {
            case .success:
                Logger.log("Files were successfully written to disk")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getElement(id: String) {
        network.getTodoItem(at: id) { result in
            switch result {
            case .success(let item):
                print(item)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadFromDrive() {
        fileCache.load { result in
            switch result {
            case .success(let todoItems):
                self.todoItems = todoItems
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    func add(_ item: TodoItem) {
        todoItems[item.id] = item
        network.uploadTodoItem(todoItem: item) { result in
            switch result {
            case .success:
                print("success upload")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func delete(id itemID: String) {
        todoItems.removeValue(forKey: itemID)
        network.deleteTodoItem(at: itemID) { result in
            switch result {
            case .success:
                print("")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    var completedTasks: Int {
        todoItems.filter({ $0.value.done }).count
    }
}
