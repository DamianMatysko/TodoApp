//
//  TodoAppApp.swift
//  TodoApp
//
//  Created by Damián Matysko on 8/24/22.
//

import SwiftUI

@main
struct TodoAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            //ContentView()
            TodoView()
            .environment(\.managedObjectContext, persistenceController.container.viewContext)

            .environmentObject(DataStore())
        }
    }
}
