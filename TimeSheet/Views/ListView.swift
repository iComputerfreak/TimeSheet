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
        NavigationView {
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
            .navigationTitle("List")
            .toolbar {
                #if DEBUG
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Generate") {
                        func randomWage() -> Double {
                            Double(Int.random(in: 12...15))
                        }
                        func randomHours() -> Double {
                            Double(Int.random(in: 0...(4 * 10))) / 4
                        }
                        func randomDate() -> Date {
                            let dateOffset = TimeInterval(Int.random(in: -300...0)) * TimeInterval.day
                            return Date.now.addingTimeInterval(dateOffset)
                        }
                        
                        var worktimes: [WorkTime] = []
                        for _ in 1...80 {
                            worktimes.append(.init(date: randomDate(), hours: randomHours(), wage: randomWage()))
                        }
                        var payouts: [Payout] = []
                        var date: Date = .now
                        for _ in 1...5 {
                            // Payouts should lie in the past and should be at least 7 days distance from each other
                            let offset = -TimeInterval(Int.random(in: 7...21)) * .day
                            date.addTimeInterval(offset)
                            payouts.append(.init(date: date, worktimes: [
                                .init(date: date, hours: randomHours(), wage: randomWage())
                            ]))
                        }
                        
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
            .environmentObject(UserData(worktimes: [
                .init(date: .now, hours: 10, wage: 12),
                .init(date: .now.addingTimeInterval(1 * 24 * 60 * 60), hours: 1, wage: 12),
                .init(date: .now.addingTimeInterval(11 * 24 * 60 * 60), hours: 6.5, wage: 12),
                .init(date: .now.addingTimeInterval(21 * 24 * 60 * 60), hours: 3, wage: 12),
                .init(date: .now.addingTimeInterval(31 * 24 * 60 * 60), hours: 7.5, wage: 15),
                .init(date: .now.addingTimeInterval(41 * 24 * 60 * 60), hours: 0.5, wage: 15),
                .init(date: .now.addingTimeInterval(51 * 24 * 60 * 60), hours: 2.3, wage: 12),
                .init(date: .now.addingTimeInterval(61 * 24 * 60 * 60), hours: 9, wage: 12),
                .init(date: .now.addingTimeInterval(71 * 24 * 60 * 60), hours: 8, wage: 15),
                .init(date: .now.addingTimeInterval(81 * 24 * 60 * 60), hours: 1.4, wage: 15),
            ].shuffled(), payouts: []))
    }
}
