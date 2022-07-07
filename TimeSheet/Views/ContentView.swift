//
//  ContentView.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

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
                    Text("Sheet")
                }
            
            PayoutsView()
                .tabItem {
                    Image(systemName: "banknote")
                    Text("Payouts")
                }
            
            HistoryView()
                .tabItem {
                    Image(systemName: "chart.xyaxis.line")
                    Text("History")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
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
