//
//  Todo.swift
//  TodoApp
//
//  Created by Damián Matysko on 8/25/22.
//

import Foundation

struct Todo: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var completed: Bool = false
    
    
    static var sampleData: [Todo] {
        [
            Todo(name: "Get Groceries", completed: false),
            Todo(name: "Get Groceries", completed: true)
        ]
    }
}

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let todoResponse = try? newJSONDecoder().decode(TodoResponse.self, from: jsonData)


// MARK: - TodoResponseElement
struct TodoResponseElement: Codable {
    let id: Int
    let name, todoResponseDescription, creationTime, expirationTime: String
    let isCompleted: Int

    enum CodingKeys: String, CodingKey {
        case id, name
        case todoResponseDescription = "description"
        case creationTime, expirationTime, isCompleted
    }
}

typealias TodoResponse = [TodoResponseElement]
