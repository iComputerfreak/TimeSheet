// Copyright © 2025 Jonas Frey. All rights reserved.

import Core
import Domain
import Foundation
import JFUtils
import Model
import SwiftUI

extension ListView {
    @Observable
    public class ViewModel: ViewModelProtocol {
        var createPayoutSheetShowing = false

        var worktimes: [WorkTime] {
            didSet { userData.worktimes = worktimes }
        }

        @ObservationIgnored
        @Injected var userData: UserData

        var years: [Int] {
            userData.worktimes
                .map(\.date.year)
                .removingDuplicates()
                .sorted(by: >)
        }

        public init() {
            @Injected var userData: UserData
            worktimes = userData.worktimes
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
            .sorted(on: \.date, by: >)
        }

        func didTapCreatePayout() {
            createPayoutSheetShowing = true
        }

        func delete(_ worktime: WorkTime) {
            worktimes.removeAll(where: { $0.id == worktime.id })
        }

        func isShowingEditButton(for worktime: WorkTime) -> Bool {
            // We don't show the edit button for fixed pay entries right now
            !worktime.isFixedPay
        }

        func worktimeBinding(for worktimeID: UUID) -> Binding<WorkTime> {
            Binding {
                self.worktimes.first { $0.id == worktimeID } ?? WorkTime(
                    date: .now,
                    activity: nil,
                    duration: .init(),
                    wage: 0
                )
            } set: { newValue in
                if let worktimeIndex = self.worktimes.firstIndex(where: { $0.id == worktimeID }) {
                    self.worktimes[worktimeIndex] = newValue
                }
            }
        }

        func headerString(year: Int, month: Int) -> String {
            let monthName = Calendar.current.standaloneMonthSymbols[month - 1]
            return "\(monthName) \(year.formatted(.number.grouping(.never)))"
        }

        func totalHours(in year: Int, month: Int) -> DateComponents {
            worktimes(in: year, month: month)
                .filter { !$0.isFixedPay }
                .map(\.duration)
                .reduce(DateComponents.zero, +)
        }

        func totalMoney(in year: Int, month: Int) -> Double {
            worktimes(in: year, month: month)
                .map(\.pay)
                .reduce(0, +)
        }
    }
}
