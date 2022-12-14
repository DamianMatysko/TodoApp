//
//  TodoView.swift
//  TodoApp
//
//  Created by Damián Matysko on 8/25/22.
//

import SwiftUI
import CoreData

struct TodoView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var dataStore: DataStore
    @State private var modalType: ModalType? = nil
    
    var body: some View {
        NavigationView{
            List(){
                ForEach(dataStore.todos){ todo in
                    Button(action: {
                        modalType = .update(todo)
                    }, label: {
                        Text(todo.name)
                            .font(.title3)
                            .strikethrough(todo.completed)
                            .foregroundColor(todo.completed ? .green : Color(.label))
                    })
                }
                .onDelete(perform: dataStore.deleteTodo)
            }
            .listStyle(InsetGroupedListStyle())
            .toolbar{
                ToolbarItem(placement: .principal){
                    Text("My Todos")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button{
                        modalType = .new
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
        }
        .sheet(item: $modalType) { $0 }
    }
}

struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        TodoView()
    }
}
