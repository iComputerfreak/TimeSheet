// Copyright © 2025 Jonas Frey. All rights reserved.

import Core
import Domain
import Foundation
import Model
import SwiftUI

extension AddFixedPayView {
    @Observable
    class ViewModel: ViewModelProtocol {
        var date = Date.now
        var activity: String = ""
        var payAmount: Double = 0
        var worktimes: Binding<[WorkTime]>?
        var editingItem: Binding<WorkTime>?
        var zeroHoursShowing = false

        var isSaveButtonDisabled: Bool {
            payAmount == 0
        }

        var dateRange: ClosedRange<Date> {
            Date(timeIntervalSinceNow: GlobalConstants.lowestValidNegativeDateInterval) ... Date()
        }

        private init() {}

        /// Creates a new AddWorkTimeView in either adding mode, adding a new work time item on save
        /// - Parameter worktimes: The list of worktimes to append the new object at
        convenience init(worktimes: Binding<[WorkTime]>) {
            self.init()
            self.worktimes = worktimes
            self.editingItem = nil
        }

        /// Creates a new AddWorkTimeView in editing mode, editing the given `editingItem`
        /// - Parameter editingItem: The work time being edited
        convenience init(editingItem: Binding<WorkTime>) {
            self.init()
            self.worktimes = nil
            self.editingItem = editingItem

            // Pre-fill the values with the ones of the editingItem
            let worktime = editingItem.wrappedValue
            self.activity = worktime.activity ?? ""
            self.date = worktime.date
            self.payAmount = worktime.pay
        }

        func invertPayAmount() {
            payAmount *= -1
        }

        func saveEntry() {
            guard payAmount != 0 else {
                zeroHoursShowing = true
                return
            }
            var newItem = WorkTime(
                date: date,
                activity: activity.isEmpty ? nil : activity,
                fixedPay: payAmount
            )
            if let worktimes {
                worktimes.wrappedValue.append(newItem)
            } else if let editingItem {
                // Keep the old id
                newItem.id = editingItem.wrappedValue.id
                editingItem.wrappedValue = newItem
            } else {
                assertionFailure(
                    "AddWorkTimeView was created with neither a list of worktimes, nor an editingItem."
                )
            }
        }
    }
}
