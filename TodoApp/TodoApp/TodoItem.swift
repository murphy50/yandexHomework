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
    let deadline: Date?
    let done: Bool
    let color: String?
    let creationDate: Date
    let changeDate: Date?
    
    init(id: String = UUID().uuidString,
         text: String,
         importance: Importance = .basic,
         deadline: Date? = nil,
         done: Bool = false,
         color: String? = nil,
         creationDate: Date = Date(),
         changeDate: Date? = nil) {
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
        var deadline: Date?
        if let doubleDeadline = jsonObject["deadline"] as? Double {
            deadline = Date(timeIntervalSince1970: doubleDeadline)
        }
        guard let done = jsonObject["done"] as? Bool else { return nil }
        let color = jsonObject["color"] as? String
        guard let doubleCreationDate = jsonObject["creationDate"] as? Double else { return nil }
        let creationDate = Date(timeIntervalSince1970: doubleCreationDate)
        var changeDate: Date?
        if let doubleChangeDate = jsonObject["changeDate"] as? Double {
            changeDate = Date(timeIntervalSince1970: doubleChangeDate)
        }
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
        if importance != .basic {
            dict["importance"] = importance.rawValue
        }
        if deadline != nil {
            dict["deadline"] = deadline?.timeIntervalSince1970
        }
        dict["done"] = done
        if let color = color {
            dict["color"] = color
        }
        dict["creationDate"] = creationDate.timeIntervalSince1970
        if let changeDate = changeDate {
            dict["changeDate"] = changeDate.timeIntervalSince1970
        }
        return dict
    }
}
