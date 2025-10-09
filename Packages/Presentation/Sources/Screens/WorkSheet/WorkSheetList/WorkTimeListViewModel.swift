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
        let canEditWorkTimes: Bool
        let canDeleteWorkTimes: Bool
        var workTimes: [WorkTime]
        var editingWorkTime: WorkTime?

        var years: [Int] {
            workTimes
                .map(\.date.year)
                .removingDuplicates()
                .sorted(by: >)
        }

        var totalWorkingDuration: DateComponents {
            workTimes
                .filter { !$0.isFixedPay }
                .map(\.duration)
                .reduce(DateComponents.zero, +)
        }

        var totalWorkTimePayIncludingDebts: Double {
            workTimes
                .map(\.pay)
                .reduce(0, +)
        }

        private var userData: UserData {
            DependencyContext.current.resolve()
        }

        init(
            navigationTitle: String,
            workTimes: [WorkTime],
            canEditWorkTimes: Bool,
            canDeleteWorkTimes: Bool
        ) {
            self.navigationTitle = navigationTitle
            self.workTimes = workTimes
            self.canEditWorkTimes = canEditWorkTimes
            self.canDeleteWorkTimes = canDeleteWorkTimes
        }

        func months(in year: Int) -> [Int] {
            workTimes
                .filter { workTime in
                    workTime.date.year == year
                }
                .map(\.date.month)
                .removingDuplicates()
                .sorted(by: >)
        }

        func workTimes(in year: Int, month: Int) -> [WorkTime] {
            workTimes.filter { workTime in
                workTime.date.year == year && workTime.date.month == month
            }
            .sorted(on: \.date, by: >)
        }

        func delete(_ workTime: WorkTime) {
            userData.workTimes.removeAll(where: { $0.id == workTime.id })
        }

        func isShowingEditButton(for workTime: WorkTime) -> Bool {
            // We don't show the edit button for fixed pay entries right now
            !workTime.isFixedPay
        }

        func workTimeBinding(for workTimeID: UUID) -> Binding<WorkTime> {
            Binding {
                self.workTimes.first { $0.id == workTimeID } ?? WorkTime(
                    date: .now,
                    activity: nil,
                    duration: .init(),
                    wage: 0
                )
            } set: { newValue in
                if let workTimeIndex = self.workTimes.firstIndex(where: { $0.id == workTimeID }) {
                    self.userData.workTimes[workTimeIndex] = newValue
                }
            }
        }

        func headerString(year: Int, month: Int) -> String {
            let monthName = Calendar.current.standaloneMonthSymbols[month - 1]
            return "\(monthName) \(year.formatted(.number.grouping(.never)))"
        }

        func totalHours(in year: Int, month: Int) -> DateComponents {
            workTimes(in: year, month: month)
                .filter { !$0.isFixedPay }
                .map(\.duration)
                .reduce(DateComponents.zero, +)
        }

        func totalMoney(in year: Int, month: Int) -> Double {
            workTimes(in: year, month: month)
                .map(\.pay)
                .reduce(0, +)
        }

        func editWorkTime(workTime: WorkTime) {
            self.editingWorkTime = workTime
        }
    }
}
