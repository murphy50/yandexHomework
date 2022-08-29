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
        }
    }
    private var delay: Double = 2
    private var factor: Double = 1.5
    private var maxDelay: Double = 120
    private var isDirty: Bool = false {
        didSet {
            if isDirty == true {
                network.createPatch(with: Array(todoItems.values), delay: delay) { [self] result in
                    print(result, delay )
                    switch result {
                    case .success(_):
                        delay = 2
                        isDirty = false
                    case .failure(_):
                        delay = min(delay * factor, maxDelay) + Double.random(in: 0...0.05)
                        isDirty = true
                    }
                }
            }
        }
    }
    
    init() {
        fileCache = FileCacheService()
        network = NetworkService()
    }
    
    func load() {
        fileCache.load { result in
            switch result {
            case .success(let todoItems):
                self.todoItems = todoItems.toDictionary
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func add(_ item: TodoItem) {
        if todoItems[item.id] != nil {
            fileCache.update(todoItem: item) { result in
                switch result {
                case .success:
                    print("successfully updated")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            fileCache.insert(todoItem: item) { result in
                switch result {
                case .success:
                    print("successfully inserted")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        todoItems[item.id] = item
    }
    
    func delete(id itemID: String) {
        todoItems.removeValue(forKey: itemID)
        fileCache.delete(id: itemID) { result in
            switch result {
            case .success:
                print("successfully deleted")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    var completedTasks: Int {
        todoItems.filter({ $0.value.done }).count
    }
}
