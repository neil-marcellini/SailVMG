//
//  SailVMGApp.swift
//  SailVMG
//
//  Created by Neil Marcellini on 11/13/20.
//

import SwiftUI

@main
struct SailVMGApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
