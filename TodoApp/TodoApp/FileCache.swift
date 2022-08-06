import Foundation


final class FileCache {
    private(set) var todoItems: [String: TodoItem] = [:]
    
    func add(_ item: TodoItem) {
        todoItems[item.id] = item
    }
    
    func delete(_ itemID: String) {
        todoItems.removeValue(forKey: itemID)
    }
    
    func save(to file: String) {
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
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func load(from file: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let fileURL = documentDirectory.appendingPathComponent(file)
        var data: Data?
        do {
            data = try Data(contentsOf: fileURL)
        } catch {
            print(error.localizedDescription)
        }
        guard let correctData = data else { return }
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: correctData) as? [Any] {
                for item in jsonArray {
                    guard let toDoItem = TodoItem.parse(json: item) else { continue }
                    add(toDoItem)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
