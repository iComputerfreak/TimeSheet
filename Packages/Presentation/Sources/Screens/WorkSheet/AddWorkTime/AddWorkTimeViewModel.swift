// Copyright © 2025 Jonas Frey. All rights reserved.

import Core
import Domain
import Foundation
import Model
import SwiftUI

extension AddWorkTimeView {
    @Observable
    public class ViewModel: ViewModelProtocol {
        let minuteSteps: Int = 5

        var date: Date {
            didSet { dateChanged = true }
        }
        var activity: String
        var hours: Int
        var minutes: Int
        var wage: Double
        var dateChanged = false

        private var worktimes: Binding<[WorkTime]>?
        private var editingItem: Binding<WorkTime>?

        var zeroHoursShowing = false

        var dateRange: ClosedRange<Date> {
            Date(timeIntervalSinceNow: GlobalConstants.lowestValidNegativeDateInterval) ... Date()
        }

        var isSaveButtonDisabled: Bool {
            hours == 0 && minutes == 0
        }

        @ObservationIgnored
        @Injected private var config: Config

        /// Creates a new AddWorkTimeView in either adding mode, adding a new work time item on save
        /// - Parameter worktimes: The list of worktimes to append the new object at
        public init(worktimes: Binding<[WorkTime]>) {
            self.worktimes = worktimes
            self.editingItem = nil
            self.date = Date()
            self.activity = ""
            self.hours = 0
            self.minutes = 0
            self.wage = 0
        }

        /// Creates a new AddWorkTimeView in editing mode, editing the given `editingItem`
        /// - Parameter editingItem: The work time being edited
        public init(editingItem: Binding<WorkTime>) {
            self.worktimes = nil
            self.editingItem = editingItem

            // Pre-fill the values with the ones of the editingItem
            let worktime = editingItem.wrappedValue
            self.activity = worktime.activity ?? ""
            self.date = worktime.date
            self.dateChanged = true // We don't want to reset it to today
            self.hours = worktime.duration.hour ?? 0
            self.minutes = worktime.duration.minute ?? 0
            self.wage = worktime.wage
        }

        func didAppear() {
            // If the user did not change the date himself, reset it to "today"
            // This works around the bug that the date seems to be stuck on old values when opening the app after a few days
            // TODO: DEBUG by putting an exact date in the form and observing if it changes when cancelling and reopening the view
            if !dateChanged {
                date = Date()
            }

            // Set the wage again from the config
            if self.editingItem == nil {
                self.wage = config.wage
            }
        }

        func saveEntry() {
            guard hours > 0 || minutes > 0 else {
                zeroHoursShowing = true
                return
            }
            var newItem = WorkTime(
                date: date,
                activity: activity.isEmpty ? nil : activity,
                hours: hours,
                minutes: minutes,
                wage: wage
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
            self.dateChanged = false
        }
    }
}
