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
    var loadTodos = Just(FileManager.docDirURL.appendingPathComponent(fileName))
    var subscriptions = Set<AnyCancellable>()
    
    init(){
        print(FileManager.docDirURL.path)
        addSubscription()
}
    
    func addSubscription(){
        loadTodos
            .filter{FileManager.default.fileExists(atPath: $0.path)}
            .tryMap{ url in
                try Data(contentsOf: url)
            }
            .decode(type: [Todo].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] (completion) in
                switch completion {
                case .finished:
                    print("Loading")
                    todoSubscription()
                case .failure(let error):
                    if error is TodoError {
                        appError = ErrorType(error: error as! TodoError)
                    } else {
                        appError = ErrorType(error: TodoError.decordingError)
                        todoSubscription()
                    }
                }
                
            } receiveValue:  {(todos) in
                self.todos = todos
            }
            .store(in: &subscriptions)
        
        addTodo
            .sink{ [unowned self] todo in
                todos.append(todo)
                
            }
            .store(in: &subscriptions)
        
        updateTodo
            .sink { [unowned self] todo in
                guard let index = todos.firstIndex(where: {
                    $0.id == todo.id }) else {return}
                todos[index] = todo
                
            }
            .store(in: &subscriptions)
        
        daleteTodo
            .sink{ [unowned self] indexSet in
                todos.remove(atOffsets: indexSet)
                
            }
            .store(in: &subscriptions)
    }
    
    func todoSubscription(){
        $todos
            .subscribe(on: DispatchQueue(label: "background queue"))
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .encode(encoder: JSONEncoder())
            .tryMap{ data in
                try data.write(to: FileManager.docDirURL.appendingPathComponent(fileName))
            }
            .sink{ [unowned self] (completion) in
                switch completion {
                case .finished:
                    print("Saving Completed")
                case .failure(let error):
                    if error is TodoError {
                        appError = ErrorType(error: error as! TodoError)
                    } else {
                        appError = ErrorType(error: TodoError.encordingError)
                    }
                }
                
            } receiveValue: { _ in
                print("Saving file was successful")
            }
            .store(in: &subscriptions)
        
    }
    
    func loadTodo(){
        FileManager().readDocument(docName: fileName){ (result) in
            switch result{
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    todos = try decoder.decode([Todo].self, from: data)
                } catch {
                    appError = ErrorType(error: .decordingError)
                }
            case .failure(let error):
                appError = ErrorType(error: error)
            }
            
        }
    }
}
