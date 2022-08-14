import Foundation
import CocoaLumberjack

protocol CacheDelegate: AnyObject {
    func updateTodoItems()
}

final class Cache {
    
    private(set) var fileCache: FileCacheService
    private(set) var network: NetworkService
    weak var delegate: CacheDelegate?
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
        // Рандомный выбор для дебага загрузки из разных источников
        if Bool.random() {
            network.getAllTodoItems { result in
                switch result {
                case .success(let todoItems):
                    for item in todoItems {
                        self.add(item)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            self.saveToDrive()
        } else {
            fileCache.load { result in
                switch result {
                case .success(let todoItems):
                    self.todoItems = todoItems
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func saveToDrive() {
        fileCache.save(todoItems: todoItems) { result in
            switch result {
            case .success:
                DDLogInfo("Files were successfully written to disk")
            case .failure(let error):
                print(error.localizedDescription)
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
    }
    
    func delete(id itemID: String) {
        todoItems.removeValue(forKey: itemID)
    }
    
    var completedTasks: Int {
        todoItems.filter({ $0.value.done }).count
    }
    
    var getArray: [TodoItem] {
        Array(todoItems.values.sorted { $0.creationDate < $1.creationDate})
    }
    
}
