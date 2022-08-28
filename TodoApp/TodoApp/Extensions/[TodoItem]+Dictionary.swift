// Created for YandexMobileSchool in 2022
// by Murphy
// Using Swift 5.0
// Running on macOS 12.5

import Foundation

extension Array where Element == TodoItem {
    var toDictionary: [String: TodoItem] {
        var dict: [String: TodoItem] = [:]
        for item in self {
            dict[item.id] = item
        }
        return dict
    }
}
