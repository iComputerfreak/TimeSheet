//
//  ContentView.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import SwiftUI
import OSLog

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    
    @StateObject private var userData = UserData()
    @StateObject private var config = Config()
    @StateObject private var payoutStore: PayoutStore
    @StateObject private var entryStore: TimeSheetEntryStore
    
    init() {
        do {
            let payoutStore = try PayoutStore.load()
            self._payoutStore = StateObject(wrappedValue: payoutStore)
            
            let entryStore = try TimeSheetEntryStore.load()
            self._entryStore = StateObject(wrappedValue: entryStore)
        } catch {
            Logger.views.error(
                // swiftlint:disable:next line_length
                "Error loading persistent data during view initialization. Continuing with empty in-memory data instead."
            )
            self._payoutStore = StateObject(wrappedValue: .init())
            self._entryStore = StateObject(wrappedValue: .init())
        }
    }
    
    var body: some View {
        TabView {
            ListView()
                .tabItem {
                    Image(systemName: "list.bullet.rectangle.portrait")
                    Text("Sheet")
                        .accessibilityIdentifier("sheet-tab")
                }
            
            PayoutsView()
                .tabItem {
                    Image(systemName: "banknote")
                    Text("Payouts")
                        .accessibilityIdentifier("payouts-tab")
                }
            
            HistoryView()
                .tabItem {
                    Image(systemName: "chart.xyaxis.line")
                    Text("History")
                        .accessibilityIdentifier("history-tab")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                        .accessibilityIdentifier("settings-tab")
                }
        }
        .environmentObject(payoutStore)
        .environmentObject(entryStore)
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
