import Foundation


final class FileCache {
    private(set) var todoItems: [String: TodoItem] = [:]
    
    func add(_ item: TodoItem) {
        todoItems[item.id] = item
    }
    
    func delete(_ itemID: String) {
        todoItems.removeValue(forKey: itemID)
    }
    
    var getArray: [TodoItem] {
        Array(todoItems.values.sorted { $0.creationDate < $1.creationDate})
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
    
    func isEmpty(file: String) -> Bool? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let fileURL = documentDirectory.appendingPathComponent(file)
        var content: String?
        do {
            content = try String(contentsOf: fileURL)
        } catch {
            print(error.localizedDescription)
        }
        if let content = content {
            return (content.isEmpty || content.count <= 2)
        }
        return nil
    }
    
    func loadTestFile() {
        
        var contents = ""
        if let filepath = Bundle.main.path(forResource: "testTodoInput", ofType: "json") {
            do {
                contents = try String(contentsOfFile: filepath)
            } catch {
                print("contents could not be loaded")
            }
        } else {
            print("test file not found")
        }
        
        if !contents.isEmpty {
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                
                let fileURL = dir.appendingPathComponent("testTodoInput.json")
                do {
                    try contents.write(to: fileURL, atomically: false, encoding: .utf8)
                    load(from: "testTodoInput.json")
                } catch {
                    
                }
            }
        }
    }
}
