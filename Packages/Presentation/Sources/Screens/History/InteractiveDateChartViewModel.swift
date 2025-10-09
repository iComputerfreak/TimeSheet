// Copyright © 2025 Jonas Frey. All rights reserved.

import Charts
import Core
import Domain
import Model
import SwiftUI

extension InteractiveDateChartView {
    @Observable
    class ViewModel: ViewModelProtocol {
        var data: [(Date, Double)]
        var graphType: GraphType
        var highlightedMonth: Date?

        /// Returns the latest 12 months sorted by date
        var displayedData: [(Date, Double)] {
            // data is already sorted
            data.suffix(12)
        }

        init(data: [(Date, Double)], graphType: GraphType) {
            self.data = Self.fillMissingMonths(data)
            self.graphType = graphType
        }

        /// Fill gaps in data (months) with zeroes, all dates normalized to the first of the month at 00:00
        static func fillMissingMonths(_ input: [(Date, Double)]) -> [(Date, Double)] {
            var data = input
            guard !data.isEmpty else { return data }
            let dates = data.map(\.0).sorted()

            // Fill gaps in data (months) with zeroes
            guard
                let firstDate = dates.first,
                let lastDate = dates.last
            else { return data }

            var currentDate = firstDate
            while currentDate < lastDate {
                // Increment date by 1 month
                guard let newDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) else { break }
                currentDate = newDate

                // Check if our current date is contained in data, otherwise add an entry with zero
                if !data.contains(where: { date, _ in
                    // Only compare month, year. day and time are irrelevant
                    date.month == currentDate.month && date.year == currentDate.year
                }) {
                    data.append((currentDate, 0))
                }
            }

            // After adding the missing values, sort the list again (by date)
            data.sort(on: \.0, by: <)

            return data
        }

        /// Returns the alignment for chart labels for the given month.
        func alignment(for month: Date) -> Alignment {
            let months = displayedData.map(\.0)
            if month == months.first {
                return .topLeading
            } else if month == months.last {
                return .topTrailing
            } else {
                return .top
            }
        }

        /// Returns the closest date to the given date that is in the displayed data.
        func nearestMonth(to date: Date) -> Date {
            guard !displayedData.isEmpty else { return date }

            // Edge cases
            let dates = displayedData.map(\.0)
            let min = dates.min()!
            let max = dates.max()!

            guard date < max else { return max }
            guard date > min else { return min }

            // If we are already at the beginning of a month, return it
            if date.day == 1 {
                return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date) ?? date
            }

            // Otherwise search for the nearest month
            func search(direction: Calendar.SearchDirection) -> Date {
                Calendar.current.nextDate(
                    after: date,
                    matching: .init(day: 1),
                    matchingPolicy: .strict,
                    repeatedTimePolicy: .first,
                    direction: direction
                ) ?? date
            }

            let prev = search(direction: .backward)
            let next = search(direction: .forward)
            if abs(prev.distance(to: date)) < abs(next.distance(to: date)) {
                return prev
            } else {
                return next
            }
        }
    }
}
