//
//  TodoFormView.swift
//  TodoApp
//
//  Created by Damián Matysko on 8/25/22.
//

import SwiftUI

struct TodoFormView: View {
    @EnvironmentObject var dataStore:DataStore
    @ObservedObject var formVM: TodoFormViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView{
            Form{
                VStack(alignment: .leading){
                    TextField("Todo", text: $formVM.name)
                    Toggle("Completed", isOn: $formVM.completed)
                }
            }
            .navigationTitle("Todo")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: cancelButton, trailing: updateSaaveButton)
        }
    }
}

extension TodoFormView{
    func updateTodo() {
        let todo = Todo(id: formVM.id!, name: formVM.name, completed: formVM.completed)
        dataStore.updateTodo.send(todo)
        presentationMode.wrappedValue.dismiss()
    }
    
    func addTodo(){
        let todo = Todo(name: formVM.name)
        dataStore.addTodo.send(todo)
        presentationMode.wrappedValue.dismiss()
    }
    
    var cancelButton: some View{
        Button("Cancel") {
            
            presentationMode.wrappedValue.dismiss()
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
