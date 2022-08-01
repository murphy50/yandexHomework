import Foundation


class FileCache {
    var todoItems: [TodoItem] = []
    
    func isUnique(_ item: TodoItem) -> Bool {
        !todoItems.contains {$0.id == item.id }
    }
    
    func add(_ item: TodoItem) {
        if isUnique(item) {
            todoItems.append(item)
        } else {
            print("not unique item")
        }
    }
    
    func delete(_ itemID: String) {
        guard let removableIndex = todoItems.firstIndex(where: { $0.id == itemID }) else {
            return
        }
        todoItems.remove(at: removableIndex)
    }
    
    func save(to file: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Directory not found")
            return
        }
        let fileURL = documentDirectory.appendingPathComponent(file)
        
        var dictionary: [[String: Any]] = []
        
        for todoItem in todoItems {
            guard let item = todoItem.json as? [String: Any] else { continue }
            dictionary.append(item)
        }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .init(rawValue: 0)) as? Data
            try jsonData?.write(to: fileURL)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func load(from file: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Directory not found")
            return
        }
        
        let fileURL = documentDirectory.appendingPathComponent(file)
        
        var data: Data?
        do {
            data = try Data(contentsOf: fileURL)
        } catch {
            print(error.localizedDescription)
        }
        guard let correctData = data else {
            print("data isn't correct")
            return
        }
        
        var dictionary: [String: Any]? = [:]
        do {
            dictionary = try JSONSerialization.jsonObject(with: correctData) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
        
        if let dictionary = dictionary, let items = dictionary["list"] as? [[String: Any]] {
            for item in items {
                guard let toDoItem = TodoItem.parse(json: item) else {
                    print("Couldn't parse the json item to ToDoItem ")
                    continue
                }
                add(toDoItem)
            }
        } else {
            print("Serialization can't return an object")
        }
    }
}
