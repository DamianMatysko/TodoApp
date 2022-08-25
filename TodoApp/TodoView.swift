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
    
    var body: some View {
        NavigationView{
            List(){
                ForEach(dataStore.todos){ todo in
                    Button(action: {
                        
                    }, label: {
                        Text(todo.name)
                            .font(.title3)
                            .strikethrough()
                            .foregroundColor(todo.completed ? .green : Color(.label))
                    })
                }
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
                        
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
        }
    }
}

struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        TodoView()
    }
}
