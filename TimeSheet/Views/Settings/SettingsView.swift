//
//  SettingsView.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import SwiftData
import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject private var config: Config
    #if DEBUG
    @EnvironmentObject private var userData: UserData
    #endif
    @Environment(\.modelContext) private var modelContext
    
    var worktimeCount: Int {
        do {
            return try modelContext.fetchCount(FetchDescriptor<WorkTime>())
        } catch {
            print("Error getting count of WorkTime objects: \(error)")
        }
        return 0
    }
    
    var body: some View {
        NavigationStack {
            Form {
                WageStepper(wage: $config.wage)
                Picker("Currency", selection: $config.currency) {
                    ForEach(Locale.commonISOCurrencyCodes, id: \.self) { code in
                        Text(code)
                    }
                }
                #if DEBUG
                
                if worktimeCount == 0 {
                    Button("Generate Screenshot Data") {
                        SampleData.screenshotWorktimes.forEach(modelContext.insert)
                        SampleData.screenshotPayouts.forEach(modelContext.insert)
                    }
                }
                #endif
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
