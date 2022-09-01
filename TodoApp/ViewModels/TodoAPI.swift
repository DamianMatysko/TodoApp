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
    
    let url = URL(string: "https://app-todoheckaton.azurewebsites.net/api/tasks")!
    let urlSession: URLSession
    
    
    internal init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func postTodo(){
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        //TODO: POKUS
        //        let date = Date()
        //        let dateFormatter = DateFormatter()
        //
        //        dateFormatter.dateFormat = "yyyy-MM-dd"
        //
        //        var resultString = dateFormatter.string(from: date)
        //        resultString += "T"
        //        dateFormatter.dateFormat = "HH:mm"
        //        resultString += dateFormatter.string(from: date)
        //
        //        print(resultString)
        
        //        let someDateTime = Date(timeIntervalSinceReferenceDate: -123456789.0).ISO8601Format(Date.ISO8601FormatStyle.TimeSeparator)
        //        print(someDateTime)
        
        
        //TODO: POKUS
        //        var data: Data = Data()
        //        let formatter = DateFormatter()
        //        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        //        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        //        let encoder = JSONEncoder()
        //        encoder.dateEncodingStrategy = .formatted(formatter)
        //        do {
        //        data = try encoder.encode(Date())
        //            print(data.randomElement())
        //        } catch {
        //            print(error)
        //        }
        
        //TODO: POKUS
        //        let formatter = DateFormatter()
        //        formatter.locale = Locale(identifier: "en_US_POSIX")
        //        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        //        let date = formatter.date(from: Date())
        //        print(date)
        //
        let parameters = TodoRequestElement(name: "test", todoRequestDescription: "test", expirationTime: "2022-08-27T18:30")
        
        
        do {
            request.httpBody = try JSONEncoder().encode(parameters)
        } catch {
            print(error)
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                error == nil
            else {                                                               // check for fundamental networking error
                print("error", error ?? URLError(.badServerResponse))
                return
            }
            
            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            
            // do whatever you want with the `data`, e.g.:
            
            do {
                let responseObject = try JSONDecoder().decode(TodoResponse.self, from: data)
                print(responseObject)
            } catch {
                print(error) // parsing error
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("responseString = \(responseString)")
                } else {
                    print("unable to parse response as string")
                }
            }
        }
        
        task.resume()
        
    }
    
    func fetchTodos() -> AnyPublisher<TodoResponse, TodoApiError>{
        //let url = URL(string: "https://app-todoheckaton.azurewebsites.net/api/tasks")!
        
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
