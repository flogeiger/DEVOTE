//
//  DEVOTEApp.swift
//  DEVOTE
//
//  Created by Florian Geiger on 18.03.25.
//

import SwiftUI

@main
struct DEVOTEApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
