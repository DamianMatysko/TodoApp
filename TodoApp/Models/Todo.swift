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
