//
//  TodoFormViewModel.swift
//  TodoApp
//
//  Created by Damián Matysko on 8/25/22.
//

import Foundation

class TodoFormViewModel: ObservableObject {
    @Published var name = ""
    @Published var completed = false
    var id: String?
    
    var updating: Bool {
        id != nil
    }
    
    var isDisabled: Bool {
        name.isEmpty
    }
    
    init(){}
    
    init(_ currentTodo: Todo){
        self.name = currentTodo.name
        self.completed = currentTodo.completed
        id = currentTodo.id
    }
}
