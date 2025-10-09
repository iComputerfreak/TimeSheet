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
    private enum TabType {
        case list
        case payouts
        case history
        case settings
    }

    @Environment(\.scenePhase) private var scenePhase

    @Injected private var userData: UserData

    @State private var selectedTab: TabType = .list

    var body: some View {
        Group {
            if #available(iOS 26.0, *) {
                latestTabView
            } else {
                tabViewFallback
            }
        }
        .onChange(of: scenePhase) { _, newValue in
            if newValue == .background {
                userData.save()
            }
        }
    }

    @available(iOS 26.0, *)
    private var latestTabView: some View {
        TabView(selection: $selectedTab) {
            Tab(
                Strings.List.navigationTitle,
                systemImage: "list.bullet.rectangle.portrait",
                value: .list
            ) {
                ListView(viewModel: .init())
            }
            .accessibilityIdentifier("sheet-tab")

            Tab(
                Strings.Payouts.navigationTitle,
                systemImage: "banknote",
                value: .payouts
            ) {
                PayoutsView()
            }
            .accessibilityIdentifier("payouts-tab")

            Tab(
                Strings.History.navigationTitle,
                systemImage: "chart.xyaxis.line",
                value: .history
            ) {
                HistoryView()
            }
            .accessibilityIdentifier("history-tab")

            Tab(
                Strings.Settings.navigationTitle,
                systemImage: "gear",
                value: .settings
            ) {
                SettingsView()
            }
            .accessibilityIdentifier("settings-tab")
        }
        .tabViewBottomAccessory {
            HStack {
                Text(Strings.List.Footer.total)
                Spacer()
                TimeView(
                    duration: userData.totalWorkingDuration,
                    amount: userData.totalWorkTimePayIncludingDebts
                )
            }
            .bold()
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
        .tabBarMinimizeBehavior(.onScrollDown)
    }

    private var tabViewFallback: some View {
        TabView {
            ListView(viewModel: .init())
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
    }
}

#if DEBUG
#Preview {
    ContentView()
}
#endif
