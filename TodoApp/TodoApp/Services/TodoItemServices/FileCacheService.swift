// Created for YandexMobileSchool in 2022
// by Murphy
// Using Swift 5.0
// Running on macOS 12.5

import Foundation
import SQLite

protocol FileCacheServiceProtocol {
    func insert(todoItem: TodoItem, completion: @escaping (Swift.Result<Void, Error>) -> Void)
    
    func delete(id: String, completion: @escaping (Swift.Result<Void, Error>) -> Void)
    
    func update(todoItem: TodoItem, completion: @escaping (Swift.Result<Void, Error>) -> Void)
    
    func load(completion: @escaping (Swift.Result<[TodoItem], Error>) -> Void)
}

final class FileCacheService: FileCacheServiceProtocol {
    
    enum Errors: Error {
        case gettingDirectoryError
        case serializationError
        case incorrectData
        case incorrectReference
    }
    
    enum Constants: String {
        case dbFile = "todoItems.sqlite3"
        case queueName = "ru.murphy.toDoApp.fileCacheServiceQueue"
    }
    
    private var dbItems = Table("todoItems")
    private var id = Expression<String>("id")
    private var text = Expression<String>("text")
    private var importance = Expression<String>("importance")
    private var deadline = Expression<Date?>("deadline")
    private var done = Expression<Bool>("done")
    private var color = Expression<String?>("color")
    private var creationDate = Expression<Date>("creationDate")
    private var changeDate = Expression<Date>("changeDate")
    
    private lazy var dbPath: URL? = {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let dbFile = Constants.dbFile.rawValue
        return documentDirectory.appendingPathComponent(dbFile)
        
    }()
    
    private let queue = DispatchQueue(label: Constants.queueName.rawValue)
    
    init() {
        createTable()
    }
    
    func createTable() {
        guard let path = dbPath else { return }
        do {
            let db = try Connection(path.path)
            try db.run(dbItems.create(temporary: false, ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(text)
                table.column(importance)
                table.column(deadline)
                table.column(done)
                table.column(color)
                table.column(creationDate)
                table.column(changeDate)
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func insert(todoItem: TodoItem, completion: @escaping (Swift.Result<Void, Error>) -> Void) {
        queue.async { [weak self] in
            guard let self = self else {
                DispatchQueue.main.async { completion(.failure(Errors.incorrectReference)) }
                return
            }
            do {
                guard let path = self.dbPath else { return }
                let db = try Connection(path.path)
                try db.run(self.dbItems.insert(self.id <- todoItem.id,
                                                    self.text <- todoItem.text,
                                                    self.importance <- todoItem.importance.rawValue,
                                                    self.deadline <- todoItem.deadline,
                                                    self.done <- todoItem.done,
                                                    self.color <- todoItem.color,
                                                    self.creationDate <- todoItem.creationDate,
                                                    self.changeDate <- todoItem.changeDate))
                DispatchQueue.main.async { completion(.success(())) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }
    
    func delete(id: String, completion: @escaping (Swift.Result<Void, Error>) -> Void) {
        queue.async { [weak self] in
            guard let self = self else {
                DispatchQueue.main.async { completion(.failure(Errors.incorrectReference)) }
                return
            }
            do {
                guard let path = self.dbPath else { return }
                let db = try Connection(path.path)
                let dbItem = self.dbItems.filter(self.id == id)
                try db.run(dbItem.delete())
                DispatchQueue.main.async { completion(.success(())) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }
    
    func update(todoItem: TodoItem, completion: @escaping (Swift.Result<Void, Error>) -> Void) {
        queue.async { [weak self] in
            guard let self = self else {
                DispatchQueue.main.async { completion(.failure(Errors.incorrectReference)) }
                return
            }
            do {
                guard let path = self.dbPath else { return }
                let db = try Connection(path.path)
                let dbItem = self.dbItems.filter(self.id == todoItem.id)
                try db.run(dbItem.update(self.id <- todoItem.id,
                                              self.text <- todoItem.text,
                                              self.importance <- todoItem.importance.rawValue,
                                              self.deadline <- todoItem.deadline,
                                              self.done <- todoItem.done,
                                              self.color <- todoItem.color,
                                              self.creationDate <- todoItem.creationDate,
                                              self.changeDate <- todoItem.changeDate))
                DispatchQueue.main.async { completion(.success(())) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }
    
    func load(completion: @escaping (Swift.Result<[TodoItem], Error>) -> Void) {
        queue.async { [weak self] in
            guard let self = self else {
                DispatchQueue.main.async { completion(.failure(Errors.incorrectReference)) }
                return
            }
            var todoItems: [TodoItem] = []
            do {
                guard let path = self.dbPath else { return }
                let db = try Connection(path.path)
                for item in try db.prepare(self.dbItems) {
                    todoItems.append(TodoItem(id: item[self.id],
                                              text: item[self.text],
                                              importance: Importance(rawValue: item[self.importance]) ?? .basic,
                                              deadline: item[self.deadline],
                                              done: item[self.done],
                                              color: item[self.color],
                                              creationDate: item[self.creationDate],
                                              changeDate: item[self.changeDate]))
                }
                DispatchQueue.main.async { completion(.success(todoItems)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }
}
