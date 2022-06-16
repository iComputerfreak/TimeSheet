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
    
    var grandTotal: DateComponents {
        userData.worktimes.map(\.duration).reduce(.zero, +)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                WorkTimeList(worktimes: userData.worktimes) { worktime in
                    self.userData.worktimes.removeAll { $0.id == worktime.id }
                }
                Divider()
                HStack {
                    Text("Total")
                    Spacer()
                    TimeView(duration: grandTotal, wage: config.wage)
                }
                .bold()
                .padding(.horizontal)
                .padding(.vertical, 10)
                Divider()
            }
            .navigationTitle("Work Times")
            .toolbar {
                #if DEBUG
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Generate") {
                        let worktimes = SampleData.generateWorkTimes()
                        let payouts = SampleData.generatePayouts()
                        Task(priority: .userInitiated) {
                            await MainActor.run {
                                withAnimation {
                                    self.userData.worktimes = worktimes
                                    self.userData.payouts = payouts
                                }
                            }
                        }
                    }
                }
                #endif
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddWorkTimeView(worktimes: $userData.worktimes)) {
                        Image(systemName: "plus")
                    }
                }
            }
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
