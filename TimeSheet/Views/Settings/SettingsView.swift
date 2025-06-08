//
//  SettingsView.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import Core
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var config: Config
    #if DEBUG
    @EnvironmentObject private var userData: UserData
    #endif

    var body: some View {
        NavigationStack {
            Form {
                WageStepper(wage: $config.wage)
                Picker(Strings.Settings.currency, selection: $config.currency) {
                    ForEach(Locale.commonISOCurrencyCodes, id: \.self) { code in
                        Text(code)
                    }
                }
                #if DEBUG
                if userData.worktimes.isEmpty {
                    Button(Strings.List.NavigationBar.generate) {
                        userData.worktimes = SampleData.screenshotWorktimes
                        userData.payouts = SampleData.screenshotPayouts
                    }
                }
                #endif
            }
            .navigationTitle(Strings.Settings.navigationTitle)
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
