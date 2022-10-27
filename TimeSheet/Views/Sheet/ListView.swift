//
//  ListView.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import SwiftUI
import Algorithms

struct ListView: View {
    @EnvironmentObject private var config: Config
    @EnvironmentObject private var userData: UserData
    @State private var payoutConfirmationShowing = false
    @State private var createPayoutSheetShowing = false
    
    var years: [Int] {
        userData.worktimes
            .map(\.date.year)
            .uniqued(on: \.hashValue)
            .sorted { $0 > $1 }
    }
    
    func months(in year: Int) -> [Int] {
        userData.worktimes
            .filter { worktime in
                worktime.date.year == year
            }
            .map(\.date.month)
            .uniqued(on: \.hashValue)
            .sorted { $0 > $1 }
    }
    
    func worktimes(in year: Int, month: Int) -> [WorkTime] {
        userData.worktimes.filter { worktime in
            worktime.date.year == year && worktime.date.month == month
        }
        .sorted { $0.date > $1.date }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                WorkTimeList(worktimes: $userData.worktimes)
                Divider()
                HStack {
                    Text("Total")
                    Spacer()
                    TimeView(duration: userData.totalWorkingDuration, amount: userData.totalWorktimePay)
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
                }
                #if DEBUG
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Generate") {
                        Task(priority: .userInitiated) {
                            let worktimes = SampleData.generateWorkTimes()
                            let payouts = SampleData.generatePayouts()
                            await MainActor.run {
                                withAnimation {
                                    self.userData.objectWillChange.send()
                                    self.userData.worktimes = worktimes
                                    self.userData.payouts = payouts
                                }
                            }
                        }
                    }
                }
                #endif
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        NavigationLink(destination: AddWorkTimeView(worktimes: $userData.worktimes)) {
                            Label("Time", systemImage: "clock")
                        }
                        NavigationLink(destination: AddFixedPayView(worktimes: $userData.worktimes)) {
                            Label("Fixed Amount", systemImage: "banknote")
                        }
                    } label: {
                        Image(systemName: "plus")
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
