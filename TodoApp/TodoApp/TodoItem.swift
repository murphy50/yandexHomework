import Foundation


struct TodoItem {
    enum Importance {
        case low, basic, important
    }
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let done: Bool
    let color: String?
    let creationDate: Date
    let changeDate: Date?
}

extension String {
    var bool: Bool? {
        switch self.lowercased() {
        case "true", "t", "yes", "y": return true
        case "false", "f", "no", "n", "": return false
        default:  return nil
        }
    }
}


extension TodoItem {
    static func parse(json: Any) -> TodoItem?{
        guard let jsonObject = json as? [String: Any] else { return nil }
        
        let id = jsonObject["id"] as? String ?? UUID().uuidString
        guard let text = jsonObject["text"] as? String else { return nil }
        let importance = jsonObject["importance"] as? Importance ?? .basic
        var deadlineDate: Date? = nil
        if let deadline = jsonObject["deadline"] as? String {
            deadlineDate =  Date(timeIntervalSince1970: Double(deadline)!)
        }
        guard let done = (jsonObject["done"] as? String)?.bool else { return nil }
        let color = jsonObject["color"] as? String
        guard let creationDateString = jsonObject["created_at"] as? String else { return nil }
        let creationDate =  Date(timeIntervalSince1970: Double(creationDateString)!)
        var changeDate: Date? = nil
        if let date = jsonObject["changed_at"] as? String {
            changeDate = Date(timeIntervalSince1970: Double(date)!)
        }
        
        return TodoItem(id: id,
                        text: text,
                        importance: importance,
                        deadline: deadlineDate,
                        done: done,
                        color: color,
                        creationDate: creationDate,
                        changeDate: changeDate)
    }
    var json: Any {
        var dict: [String: Any] = [:]
        dict["id"] = self.id
        dict["text"] = self.id
        if importance != .basic {
            dict["importance"] = self.importance
        }
        if deadline != nil {
            dict["deadline"] = self.deadline?.timeIntervalSince1970
        }
        return dict
    }
}

