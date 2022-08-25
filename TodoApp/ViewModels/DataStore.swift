//
//  DataStore.swift
//  TodoApp
//
//  Created by Damián Matysko on 8/25/22.
//

import Foundation

class DataStore: ObservableObject {
    @Published var todos:[Todo] = []
    
    init(){
        loadTodo()
    }
    
    func addTodo(_ todo: Todo) {
        todos.append(todo)
    }
    
    func updateTodo(_ todo: Todo) {
        guard let index = todos.firstIndex(where: { $0.id == todo.id}) else {return}
        todos[index] = todo
        
    }
    
    func deleteTodo(at indexSet: IndexSet){
        todos.remove(atOffsets: indexSet)
    }
    
    func loadTodo(){
        todos = Todo.sampleData
    }
}
