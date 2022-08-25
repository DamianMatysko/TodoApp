//
//  TodoError.swift
//  TodoApp
//
//  Created by Damián Matysko on 8/25/22.
//

import Foundation

enum TodoError: Error, LocalizedError {
    case saveError
    case readError
    case decordingError
    case encordingError
    
    var errorDescription: String? {
        switch self {
        case .saveError:
            return NSLocalizedString("Could not save Todos, please reinstall the app.", comment: "")
        case .readError:
            return NSLocalizedString("Could not load Todos, please reinstall the app.", comment: "")
        case .decordingError:
            return NSLocalizedString("There was problem with loading your Todos, please createn a new Todo to start over.", comment: "")
        case .encordingError:
            return NSLocalizedString("Could not save Todos, please reinstall the app.", comment: "")
        }
    }
}

struct ErrorType: Identifiable {
    let id = UUID()
    let error: TodoError
}
