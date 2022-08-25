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
        print(FileManager.docDirURL.path)
        if FileManager().docExist(named: fileName){
            loadTodo()
        }
        
    }
    
    func addTodo(_ todo: Todo) {
        todos.append(todo)
        saveTodos()
    }
    
    func updateTodo(_ todo: Todo) {
        guard let index = todos.firstIndex(where: { $0.id == todo.id}) else {return}
        todos[index] = todo
        saveTodos()
    }
    
    func deleteTodo(at indexSet: IndexSet){
        todos.remove(atOffsets: indexSet)
        saveTodos()
    }
    
    func loadTodo(){
//        todos = Todo.sampleData
        FileManager().readDocument(docName: fileName){ (result) in
            switch result{
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    todos = try decoder.decode([Todo].self, from: data)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
    func saveTodos(){
        print("Saving todos")
        let encoder = JSONEncoder()
        do{
            let data = try encoder.encode(todos)
            let jsonString = String(decoding: data, as: UTF8.self)
            FileManager().saveDocument(contents: jsonString, docName: fileName){ (error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
