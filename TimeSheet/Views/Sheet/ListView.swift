//
//  ListView.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import Core
import Domain
import JFUtils
import Model
import SwiftUI

struct ListView: View {
    @Injected private var config: Config
    @Injected private var userData: UserData
    @State private var payoutConfirmationShowing = false
    @State private var createPayoutSheetShowing = false

    var years: [Int] {
        userData.worktimes
            .map(\.date.year)
            .removingDuplicates()
            .sorted(by: >)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                WorkTimeList(worktimes: $userData.worktimes)
                Divider()
                HStack {
                    Text(Strings.List.Footer.total)
                    Spacer()
                    TimeView(duration: userData.totalWorkingDuration, amount: userData.totalWorktimePayIncludingDebts)
                }
                .bold()
                .padding(.horizontal)
                .padding(.vertical, 10)
                Divider()
            }
            .navigationTitle(Strings.List.navigationTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(Strings.List.NavigationBar.payout) {
                        createPayoutSheetShowing = true
                    }
                    .accessibilityIdentifier("payout-button")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        NavigationLink(destination: AddWorkTimeView(worktimes: $userData.worktimes)) {
                            Label(Strings.CreateEntry.time, systemImage: "clock")
                                .accessibilityIdentifier("time-based")
                        }
                        NavigationLink(destination: AddFixedPayView(worktimes: $userData.worktimes)) {
                            Label(Strings.CreateEntry.fixedAmount, systemImage: "banknote")
                                .accessibilityIdentifier("fixed-amount")
                        }
                    } label: {
                        Image(systemName: "plus")
                            .accessibilityIdentifier("add")
                    }
                }
            }
        }
        .sheet(isPresented: $createPayoutSheetShowing) {
            CreatePayoutView()
        }
    }

    func months(in year: Int) -> [Int] {
        userData.worktimes
            .filter { worktime in
                worktime.date.year == year
            }
            .map(\.date.month)
            .removingDuplicates()
            .sorted(by: >)
    }

    func worktimes(in year: Int, month: Int) -> [WorkTime] {
        userData.worktimes.filter { worktime in
            worktime.date.year == year && worktime.date.month == month
        }
        .sorted { $0.date > $1.date }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
            .environment(\.locale, Locale(identifier: "de"))
            .environmentObject(Config())
            .environmentObject(SampleData.userData)
    }
}
