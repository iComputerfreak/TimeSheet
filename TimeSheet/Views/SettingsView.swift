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
                Stepper(value: config.$wage, in: 0...100, step: 0.5, format: .currency(code: "EUR")) {
                    HStack {
                        Text("Hourly wage")
                        Spacer()
                        Text(config.wage.formatted(.currency(code: "EUR")))
                    }
                }
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
