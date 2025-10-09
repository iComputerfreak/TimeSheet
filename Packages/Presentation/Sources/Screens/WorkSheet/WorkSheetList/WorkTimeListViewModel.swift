// Copyright © 2025 Jonas Frey. All rights reserved.

import Core
import Domain
import Foundation
import JFUtils
import Model
import SwiftUI

extension WorkTimeListView {
    @Observable
    class ViewModel: ViewModelProtocol {
        let navigationTitle: String
        let canEditWorktimes: Bool
        let canDeleteWorktimes: Bool
        var worktimes: [WorkTime]
        var editingWorkTime: WorkTime?

        var years: [Int] {
            worktimes
                .map(\.date.year)
                .removingDuplicates()
                .sorted(by: >)
        }

        var totalWorkingDuration: DateComponents {
            worktimes
                .filter { !$0.isFixedPay }
                .map(\.duration)
                .reduce(DateComponents.zero, +)
        }

        var totalWorktimePayIncludingDebts: Double {
            worktimes
                .map(\.pay)
                .reduce(0, +)
        }

        private var userData: UserData {
            DependencyContext.current.resolve()
        }

        init(
            navigationTitle: String,
            worktimes: [WorkTime],
            canEditWorktimes: Bool,
            canDeleteWorktimes: Bool
        ) {
            self.navigationTitle = navigationTitle
            self.worktimes = worktimes
            self.canEditWorktimes = canEditWorktimes
            self.canDeleteWorktimes = canDeleteWorktimes
        }

        func months(in year: Int) -> [Int] {
            worktimes
                .filter { worktime in
                    worktime.date.year == year
                }
                .map(\.date.month)
                .removingDuplicates()
                .sorted(by: >)
        }

        func worktimes(in year: Int, month: Int) -> [WorkTime] {
            worktimes.filter { worktime in
                worktime.date.year == year && worktime.date.month == month
            }
            .sorted(on: \.date, by: >)
        }

        func delete(_ worktime: WorkTime) {
            userData.worktimes.removeAll(where: { $0.id == worktime.id })
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
                    self.userData.worktimes[worktimeIndex] = newValue
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

        func editWorkTime(workTime: WorkTime) {
            self.editingWorkTime = workTime
        }
    }
}
