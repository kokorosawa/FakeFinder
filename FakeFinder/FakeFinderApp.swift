//
//  FakeFinderApp.swift
//  FakeFinder
//
//  Created by 吳念澤 on 2025/5/12.
//

import SwiftUI

@main
struct FakeFinderApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
