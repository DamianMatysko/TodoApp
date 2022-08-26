//
//  TodoAPI.swift
//  TodoApp
//
//  Created by Damián Matysko on 8/26/22.
//

import Foundation
import Combine

enum TodoApiError: Error{
    case fetchFaild
    case responseError
    case invalidURL
    case invalidParameter
    case objectDecordError
    case generalError(Error)
    case serverError(Int)
}

class TodoAPI {
  //  let baseURL = "https://app-todoheckaton.azurewebsites.net/api"
    let urlSession: URLSession
    
    
    internal init(urlSession: URLSession = URLSession.shared) {
           self.urlSession = urlSession
       }
    

    func fetchTodos() -> AnyPublisher<TodoResponse, TodoApiError>{
        let url = URL(string: "https://app-todoheckaton.azurewebsites.net/api/tasks")!
        
            let request = URLRequest(url: url)
            
            let decoder = JSONDecoder()
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy HH:mm:ss a"
            decoder.dateDecodingStrategy = .formatted(formatter)
            
            return URLSession.shared.dataTaskPublisher(for: request)
                .tryMap({(data: Data, response: URLResponse) in
                    guard let urlRespose = response as? HTTPURLResponse, urlRespose.statusCode < 400 else{
                        if let urlRespose = response as? HTTPURLResponse {
                            throw TodoApiError.serverError(urlRespose.statusCode)
                        }
                        throw TodoApiError.fetchFaild
                    }
                    return data
                })
                .decode(type: TodoResponse.self, decoder: decoder)
                .mapError({ failure in
                    TodoApiError.fetchFaild
                })
                .eraseToAnyPublisher()
        
    }
 

        func fetchTodosToFolder(){
            let url = URL(string: "https://app-todoheckaton.azurewebsites.net/api/tasks")!
            //let localUrl = FileManager.docDirURL.appendingPathComponent(fileName)
    
            let task = URLSession.shared.downloadTask(with: url) { localURL, urlResponse, error in
                if let localURL = localURL {
                    if let string = try? String(contentsOf: localURL) {
                        print(localURL)
                        print(string)
                    }
                }
            }
    
            task.resume()
        }
        
        
    
    
}
