//
//  DataStore.swift
//  TodoApp
//
//  Created by Damián Matysko on 8/25/22.
//

import Foundation
import Combine

class DataStore: ObservableObject {
    var todos = CurrentValueSubject<[Todo], Never>([])
    var appError = CurrentValueSubject<ErrorType?, Never>(nil)
    var addTodo = PassthroughSubject<Todo, Never>()
    var updateTodo = PassthroughSubject<Todo, Never>()
    var daleteTodo = PassthroughSubject<IndexSet, Never>()
    var loadTodos = Just(FileManager.docDirURL.appendingPathComponent(fileName))
    var subscriptions = Set<AnyCancellable>()
    
    var cancellable: Set<AnyCancellable> = [] //TODO: same variable as subscriptions
    var api: TodoAPI = TodoAPI()
//    @Published var todosAPI: Loadable<TodoResponse> = .notLoaded
    
    enum Loadable<Response>{
        case notLoaded
        case loaded(Response)
        case failed(Error)
    }
    
    init(){
        print(FileManager.docDirURL.path)
        addSubscription()
        api.postTodo()
    }
    
    func test(){
        api.fetchTodos()
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("We have data!")
                case .failure(let weatherError):
                    print("Something went wrong: \(weatherError.localizedDescription)")
                }
            } receiveValue: { response in
            print(response)
            }
            .store(in: &cancellable)
    }
    
    func addSubscription(){
        appError
            .sink{ _ in
                self.objectWillChange.send()
            }
            .store(in: &subscriptions)
        
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
                        appError.send(ErrorType(error: error as! TodoError))
                    } else {
                        appError.send(ErrorType(error: TodoError.decordingError))
                        todoSubscription()
                    }
                }
                
            } receiveValue:  {(todos) in
                self.todos.value = todos
                self.objectWillChange.send()
            }
            .store(in: &subscriptions)
        
        addTodo
            .sink{ [unowned self] todo in
                todos.value.append(todo)
                self.objectWillChange.send()
            }
            .store(in: &subscriptions)
        
        updateTodo
            .sink { [unowned self] todo in
                guard let index = todos.value.firstIndex(where: {
                    $0.id == todo.id }) else {return}
                todos.value[index] = todo
                self.objectWillChange.send()
            }
            .store(in: &subscriptions)
        
        daleteTodo
            .sink{ [unowned self] indexSet in
                todos.value.remove(atOffsets: indexSet)
                self.objectWillChange.send()
            }
            .store(in: &subscriptions)
    }
    
    func todoSubscription(){
        todos
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
                        appError.send(ErrorType(error: error as! TodoError))
                    } else {
                        appError.send(ErrorType(error: TodoError.encordingError))
                    }
                }
                
            } receiveValue: { _ in
                print("Saving file was successful")
            }
            .store(in: &subscriptions)
        
        //todosAPI TODO: subscription
        
    }
    
    
   

    

    
    
}
