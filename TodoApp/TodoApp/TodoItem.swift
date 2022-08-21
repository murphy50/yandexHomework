// Created for YandexMobileSchool in 2022
// by Murphy
// Using Swift 5.0
// Running on macOS 12.5

import Foundation
import MyColors

struct TodoItem {
    enum Importance: String {
        case low, basic, important
    }
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date
    let done: Bool
    let color: String?
    let creationDate: Date
    let changeDate: Date
    
    init(id: String = UUID().uuidString,
         text: String,
         importance: Importance = .basic,
         deadline: Date = Date(),
         done: Bool = false,
         color: String? = nil,
         creationDate: Date = Date(),
         changeDate: Date = Date()) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.done = done
        self.color = color
        self.creationDate = creationDate
        self.changeDate = changeDate
    }
}

extension TodoItem {
    static func parse(json: Any) -> TodoItem? {
        guard let jsonObject = json as? [String: Any] else { return nil }
        
        guard let id = jsonObject["id"] as? String else { return nil }
        guard let text = jsonObject["text"] as? String else { return nil }
        let importance = Importance(rawValue: jsonObject["importance"] as? String ?? "basic") ?? .basic
        
        guard let doubleDeadline = jsonObject["deadline"] as? Double else { return nil }
        let deadline = Date(timeIntervalSince1970: doubleDeadline)
        guard let done = jsonObject["done"] as? Bool else { return nil }
        let color = jsonObject["color"] as? String
        guard let doubleCreationDate = jsonObject["created_at"] as? Double else { return nil }
        let creationDate = Date(timeIntervalSince1970: doubleCreationDate)
        
        guard let doubleChangeDate = jsonObject["changed_at"] as? Double else { return nil }
        let changeDate = Date(timeIntervalSince1970: doubleChangeDate)
        
        return TodoItem(id: id,
                        text: text,
                        importance: importance,
                        deadline: deadline,
                        done: done,
                        color: color,
                        creationDate: creationDate,
                        changeDate: changeDate)
    }
    var json: Any {
        var dict: [String: Any] = [:]
        dict["id"] = id
        dict["text"] = text
        dict["importance"] = importance.rawValue
        
        dict["deadline"] = deadline.timeIntervalSince1970
        dict["done"] = done
        if let color = color {
            dict["color"] = color
        }
        dict["creationDate"] = creationDate.timeIntervalSince1970
        dict["changeDate"] = changeDate.timeIntervalSince1970
        return dict
    }
    var jsonToNetwork: Any {
        var dict: [String: Any] = [:]
        dict["id"] = id
        dict["text"] = text
        dict["importance"] = importance.rawValue
        dict["last_updated_by"] = "me"
        dict["deadline"] = Int(deadline.timeIntervalSince1970 * 1_000_000)
        dict["done"] = done
        if let color = color {
            dict["color"] = color
        }
        dict["created_at"] = Int(creationDate.timeIntervalSince1970 * 1_000_000)
        dict["changed_at"] = Int(changeDate.timeIntervalSince1970 * 1_000_000)

        return dict
    }
}
