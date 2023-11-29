//
//  ListView.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import SwiftData
import SwiftUI
import Algorithms
import JFUtils

struct ListView: View {
    @EnvironmentObject private var config: Config
    @EnvironmentObject private var userData: UserData
    @State private var payoutConfirmationShowing = false
    @State private var createPayoutSheetShowing = false
    
    @Query(sort: [.init(\WorkTime.date)], animation: .default)
    private var worktimes: [WorkTime]
    
    var years: [Int] {
        worktimes
            .map(\.date.year)
            .uniqued(on: \.hashValue)
            .sorted(by: >)
    }
    
    func months(in year: Int) -> [Int] {
        worktimes
            .filter { worktime in
                worktime.date.year == year
            }
            .map(\.date.month)
            .uniqued(on: \.hashValue)
            .sorted(by: >)
    }
    
    // TODO: Should probably be done in a Query in a subview
    func worktimes(in year: Int, month: Int) -> [WorkTime] {
        worktimes.filter { worktime in
            worktime.date.year == year && worktime.date.month == month
        }
        .sorted(on: \.date, by: >)
    }
    
    var totalWorkingDuration: TimeInterval {
        worktimes
            .filter { !$0.isFixedPay }
            .filter { $0.pay > 0 }
            .map(\.duration)
            .reduce(0, +)
    }
    
    var totalWorkHoursPayIncludingDebts: Double {
        worktimes
        // TODO: Only works after fixed payouts have been given their own data type
            .map(\.pay)
            .reduce(0, +)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                WorkTimeList()
                Divider()
                HStack {
                    Text("Total")
                    Spacer()
                    TimeView(duration: totalWorkingDuration, amount: totalWorkHoursPayIncludingDebts)
                }
                .bold()
                .padding(.horizontal)
                .padding(.vertical, 10)
                Divider()
            }
            .navigationTitle("Work Times")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Payout") {
                        createPayoutSheetShowing = true
                    }
                    .accessibilityIdentifier("payout-button")
                }
//                #if DEBUG
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button("Generate") {
//                        Task(priority: .userInitiated) {
//                            let worktimes = SampleData.generateWorkTimes()
//                            let payouts = SampleData.generatePayouts()
//                            await MainActor.run {
//                                withAnimation {
//                                    self.userData.objectWillChange.send()
//                                    self.userData.worktimes = worktimes
//                                    self.userData.payouts = payouts
//                                }
//                            }
//                        }
//                    }
//                }
//                #endif
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        NavigationLink(destination: AddWorkTimeView(worktimes: $userData.worktimes)) {
                            Label("Time", systemImage: "clock")
                                .accessibilityIdentifier("time-based")
                        }
                        NavigationLink(destination: AddFixedPayView(worktimes: $userData.worktimes)) {
                            Label("Fixed Amount", systemImage: "banknote")
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
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
            .environment(\.locale, Locale(identifier: "de"))
            .environmentObject(Config())
            .environmentObject(SampleData.userData)
    }
}
