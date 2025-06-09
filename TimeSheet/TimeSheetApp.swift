//
//  TimeSheetApp.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import SwiftUI

@main
struct TimeSheetApp: App {
    @State private var dependencyInitializer: DependencyInitializer = .init()

    var body: some Scene {
        WindowGroup {
            if dependencyInitializer.didRegisterDependencies {
                ContentView()
            } else {
                Text("Dependencies not initialized")
                    .task {
                        await dependencyInitializer.register()
                    }
            }
        }
    }
}
