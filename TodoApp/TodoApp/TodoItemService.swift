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
            network.createPatch(with: Array(todoItems.values)) { [self] result in
                switch result {
                case .success(_):
                    isDirty = false
                case .failure(_):
                    isDirty = true
                }
            }
            delegate?.updateTodoItems()
            saveToDrive()
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
    
    init(_ fileCache: FileCacheService, _ network: NetworkService) {
        self.fileCache = fileCache
        self.network = network
    }
    
    func load() {
        fileCache.load { result in
            switch result {
            case .success(let todoItems):
                if todoItems.isEmpty {
                    fallthrough              // !fallthrowing
                }
                self.todoItems = todoItems
            case .failure:
                self.network.getAllTodoItems { [self] result in
                    switch result {
                    case .success(let todoItems):
                        for item in todoItems {
                            self.add(item)
                        }
                    case .failure(let error):
                        isDirty = true
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
        network.getTodoItem(at: id) { [self] result in
            switch result {
            case .success(let item):
                print(item)
            case .failure(let error):
                isDirty = true
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
        // FIXME: - change logic of .success
        if todoItems.contains(where: { $0.value.id == item.id }) {
            network.editTodoItem(todoItem: item) { result in
                switch result {
                case .success:
                    print("successfully editing")
                case .failure(let error):
                    print(error.localizedDescription)
                    self.isDirty = true
                }
            }
        } else {
            network.uploadTodoItem(todoItem: item) { result in
                switch result {
                case .success:
                    print("successfully editing")
                case .failure(let error):
                    print(error.localizedDescription)
                    self.isDirty = true
                }
            }
        }
        todoItems[item.id] = item
    }
    
    func delete(id itemID: String) {
        todoItems.removeValue(forKey: itemID)
        network.deleteTodoItem(at: itemID) { result in
            switch result {
            case .success:
                print("")
            case .failure(let error):
                print(error)
                self.isDirty = true
            }
        }
    }
    
    var completedTasks: Int {
        todoItems.filter({ $0.value.done }).count
    }
}
