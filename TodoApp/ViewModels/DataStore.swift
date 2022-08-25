//
//  DataStore.swift
//  TodoApp
//
//  Created by Damián Matysko on 8/25/22.
//

import Foundation
import Combine

class DataStore: ObservableObject {
    @Published var todos:[Todo] = []
    @Published var appError: ErrorType? = nil
    
    var addTodo = PassthroughSubject<Todo, Never>()
    var updateTodo = PassthroughSubject<Todo, Never>()
    var daleteTodo = PassthroughSubject<IndexSet, Never>()
    
    var subscriptions = Set<AnyCancellable>()
    
    init(){
        print(FileManager.docDirURL.path)
        if FileManager().docExist(named: fileName){
            loadTodo()
        }
        
    }
    
    func addSubscription(){
        addTodo
            .sink{ [unowned self] todo in
                todos.append(todo)
                saveTodos()
            }
            .store(in: &subscriptions)
        
        updateTodo
            .sink { [unowned self] todo in
                guard let index = todos.firstIndex(where: {
                    $0.id == todo.id }) else {return}
                todos[index] = todo
                saveTodos()
            }
            .store(in: &subscriptions)
        
        daleteTodo
            .sink{ [unowned self] indexSet in
                todos.remove(atOffsets: indexSet)
                saveTodos()
            }
            .store(in: &subscriptions)
    }
    
    
//    func addTodo(_ todo: Todo) {
//        todos.append(todo)
//        saveTodos()
//    }
//
//    func updateTodo(_ todo: Todo) {
//        guard let index = todos.firstIndex(where: { $0.id == todo.id}) else {return}
//        todos[index] = todo
//        saveTodos()
//    }
//
//    func deleteTodo(at indexSet: IndexSet){
//        todos.remove(atOffsets: indexSet)
//        saveTodos()
//    }
    
    func loadTodo(){
        //        todos = Todo.sampleData
        FileManager().readDocument(docName: fileName){ (result) in
            switch result{
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    todos = try decoder.decode([Todo].self, from: data)
                } catch {
                    // print(TodoError.decordingError.localizedDescription)
                    appError = ErrorType(error: .decordingError)
                }
            case .failure(let error):
                // print(error.localizedDescription)
                appError = ErrorType(error: error)
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
                    //print(error.localizedDescription)
                    
                    appError = ErrorType(error: error)
                }
            }
        } catch {
            // print(TodoError.encordingError.localizedDescription)
            appError = ErrorType(error: .encordingError)
        }
    }
}
