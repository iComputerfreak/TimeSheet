//
//  SettingsView.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject private var config: Config
    
    var body: some View {
        NavigationView {
            Form {
                WageStepper(wage: $config.wage)
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environment(\.locale, Locale(identifier: "de"))
            .environmentObject(Config())
    }
}
