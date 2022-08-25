//
//  ModalType.swift
//  TodoApp
//
//  Created by Damián Matysko on 8/25/22.
//

//import Foundation
import SwiftUI

enum ModalType: Identifiable, View {
    case new
    case update(Todo)
    
    var id: String {
        switch self{
        case .new:
            return "new"
        case .update:
            return "update"
        }
    }
    
    var body: some View{
        switch self{
        case .new:
            return TodoFormView(formVM: TodoFormViewModel())
        case .update(let todo):
            return TodoFormView(formVM: TodoFormViewModel(todo))
        }
    }
}
