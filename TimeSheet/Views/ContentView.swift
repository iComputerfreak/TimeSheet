//
//  ContentView.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import Core
import Domain
import Model
import Presentation
import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase

    @Injected private var userData: UserData

    var body: some View {
        TabView {
            ListView()
                .tabItem {
                    Image(systemName: "list.bullet.rectangle.portrait")
                    Text(Strings.List.navigationTitle)
                        .accessibilityIdentifier("sheet-tab")
                }

            PayoutsView()
                .tabItem {
                    Image(systemName: "banknote")
                    Text(Strings.Payouts.navigationTitle)
                        .accessibilityIdentifier("payouts-tab")
                }

            HistoryView()
                .tabItem {
                    Image(systemName: "chart.xyaxis.line")
                    Text(Strings.History.navigationTitle)
                        .accessibilityIdentifier("history-tab")
                }

            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text(Strings.Settings.navigationTitle)
                        .accessibilityIdentifier("settings-tab")
                }
        }
        .onChange(of: scenePhase) { _, newValue in
            if newValue == .background {
                userData.save()
            }
        }
    }
}

#if DEBUG
#Preview {
    ContentView()
}
#endif
