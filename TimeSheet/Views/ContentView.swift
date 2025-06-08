//
//  ContentView.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import Core
import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase

    @StateObject private var userData = UserData()
    @StateObject private var config = Config()

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
        .environmentObject(userData)
        .environmentObject(config)
        .onChange(of: scenePhase) { newValue in
            if newValue == .background {
                userData.save()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
