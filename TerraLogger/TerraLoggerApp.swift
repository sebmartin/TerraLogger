// Copyright (C) 2025 Sebastien Martin
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.

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
