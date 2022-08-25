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
        
    }
    
    func updateTodo(_ todo: Todo) {
        
    }
    
    func deleteTodo(at indexSet: IndexSet){
        
    }
    
    func loadTodo(){
        todos = Todo.sampleData
    }
}
