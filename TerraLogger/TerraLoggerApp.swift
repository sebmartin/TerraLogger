//
//  TerraLoggerApp.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-07-15.
//

import SwiftUI
import SwiftData

let allModels: [any PersistentModel.Type] = [
    Boundary.self,
    Trail.self,
    Coordinate.self
]

@main
struct TerraLoggerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema(allModels)
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(sharedModelContainer)
    }
}
