//
//  TodoFormView.swift
//  TodoApp
//
//  Created by Damián Matysko on 8/25/22.
//

import SwiftUI

struct TodoFormView: View {
    @EnvironmentObject var dataStore:DataStore
    @ObservedObject var formVM: TodoFormViewModel//TODO: not working keyboard
    enum Field {//TODO: not working keyboard
        case todo
    }
    @Environment(\.dismiss) var dismiss
    @FocusState private var focusedField:Field?
    
    var body: some View {
        NavigationView{
            
            VStack(alignment: .leading){
                TextField("Todo", text: $formVM.name)
                    .focused($focusedField, equals: .todo)//TODO: not working keyboard
                Toggle("Completed", isOn: $formVM.completed)
                Spacer()//TODO: not working keyboard
            }
            .padding()//TODO: not working keyboard
            .task {//TODO: not working keyboard
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    focusedField = .todo
                }
            }
            
            
            .navigationTitle("Todo")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: cancelButton, trailing: updateSaaveButton)
            .toolbar{ //TODO: not working keyboard
                ToolbarItemGroup(placement: .keyboard){
                    HStack{
                        Spacer()
                        Button{
                            focusedField = nil
                        } label: {
                            Image(systemName: "keyboard.chevron.compact.down")
                        }
                    }
                }
            }
        }
    }
}

extension TodoFormView{
    func updateTodo() {
        let todo = Todo(id: formVM.id!, name: formVM.name, completed: formVM.completed)
        dataStore.updateTodo.send(todo)
        dismiss()
    }
    
    func addTodo(){
        let todo = Todo(name: formVM.name)
        dataStore.addTodo.send(todo)
        dismiss()
    }
    
    var cancelButton: some View{
        Button("Cancel") {
            dismiss()
        }
    }
    
    var updateSaaveButton: some View {
        Button(formVM.updating ? "Update" : "Save", action: formVM.updating ? updateTodo : addTodo)
            .disabled(formVM.isDisabled)
    }
}

struct TodoFormView_Previews: PreviewProvider {
    static var previews: some View {
        TodoFormView(formVM: TodoFormViewModel())
            .environmentObject(DataStore())
    }
}
