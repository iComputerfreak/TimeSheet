//
//  InteractiveDateChart.swift
//  TimeSheet
//
//  Created by Jonas Frey on 10.06.22.
//

import SwiftUI
import Charts

struct InteractiveDateChart: View {
    var data: [(Date, Double)]
    var graphType: GraphType

    @EnvironmentObject private var config: Config
    @State private var highlightedMonth: Date?

    var displayedData: [(Date, Double)] {
        // Display the latest 12 months (data is already sorted)
        data.suffix(12)
    }

    init(data: [(Date, Double)], graphType: GraphType) {
        // Fill gaps in data (months) with zeroes
        var data = data
        let dates = data.map(\.0).sorted()
        var currentDate = dates.first!
        repeat {
            // Increment date
            var newMonth = currentDate.month + 1
            var newYear = currentDate.year
            // Month overflow
            if newMonth > 12 {
                newMonth = 1
                newYear += 1
            }
            currentDate = Calendar.current.date(from: .init(year: newYear, month: newMonth, day: 1))!

            // Check if our current date is contained in data, otherwise add an entry with zero
            if !data.contains(where: { (date, amount) in
                // Only compare month, year. day and time are irrelevant
                date.month == currentDate.month && date.year == currentDate.year
            }) {
                data.append((currentDate, 0))
            }
        } while currentDate < dates.last!

        // After adding the missing values, sort the list again (by date)
        data.sort { $0.0 < $1.0 }

        self.data = data
        self.graphType = graphType
    }

    var body: some View {
        Chart {
            ForEach(displayedData, id: \.0) { date, amount in
                // Move the data point into the middle of the month
                AreaMark(
                    x: .value("Date", date),
                    y: .value(graphType.yLabel, amount)
                )
                .interpolationMethod(.linear)
                .foregroundStyle(Gradient(colors: [.green.opacity(0.6), .green]))
                LineMark(
                    x: .value("Date", date),
                    y: .value(graphType.yLabel, amount)
                )
                .interpolationMethod(.linear)
                .foregroundStyle(.green)
            }
            if let highlightedMonth {
                let value = displayedData.first(where: { $0.0 == highlightedMonth })?.1 ?? 0
                BarMark(
                    x: .value("Date", highlightedMonth),
                    yStart: .value(graphType.yLabel, 0),
                    yEnd: .value(graphType.yLabel, value),
                    width: .fixed(2)
                )
                .foregroundStyle(.primary)
                .annotation(
                    position: .top,
                    alignment: alignment(for: highlightedMonth)
                ) {
                    AnnotationView(date: highlightedMonth, value: value, graphType: graphType)
                        .environmentObject(config)
                }
            }
        }
        .chartXScale(range: .plotDimension(padding: 15))
        .chartXAxis {
            AxisMarks(values: .stride(by: .month) ) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel(
                    format: .dateTime.month(.abbreviated)
                )
            }
        }
        .chartOverlay { proxy in
            GeometryReader { nthGeoItem in
                Rectangle().fill(.clear).contentShape(Rectangle())
                    .gesture(DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            // Find the x-coordinates in the chart’s plot area.
                            let xCurrent = value.location.x - nthGeoItem[proxy.plotAreaFrame].origin.x
                            // Find the date value at the x-coordinate.
                            let date: Date = proxy.value(atX: xCurrent) ?? .now
                            // Snap to nearest month
                            let nearest = nearestMonth(to: date)
                            assert(nearest <= displayedData.map(\.0).max() ?? nearest)
                            assert(nearest >= displayedData.map(\.0).min() ?? nearest)
                            highlightedMonth = nearest
                        }
                        .onEnded { _ in highlightedMonth = nil } // Clear the state on gesture end.
                    )
            }
        }
    }

    private func alignment(for month: Date) -> Alignment {
        let months = displayedData.map(\.0)
        if month == months.first {
            return .topLeading
        } else if month == months.last {
            return .topTrailing
        } else {
            return .top
        }
    }

    @available(*, unavailable)
    private func middleOfMonth(_ date: Date) -> Date {
        date.addingTimeInterval(TimeInterval(numberOfDays(in: date)) / 2 * .day)
    }

    private func numberOfDays(in month: Date) -> Int {
        Calendar.current.range(of: .day, in: .month, for: month)?.count ?? 0
    }

    private func nearestMonth(to date: Date) -> Date {
        guard !displayedData.isEmpty else {
            return date
        }

        // Edge cases
        let dates = displayedData.map(\.0)
        let min = dates.min()!
        let max = dates.max()!

        guard date < max else {
            return max
        }
        guard date > min else {
            return min
        }

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

struct InteractiveDateChart_Previews: PreviewProvider {
    static var worktimesByMonth: [Date: [WorkTime]] {
        Dictionary(
            grouping: SampleData.generateWorkTimes(),
            by: { worktime in
                Calendar.current.date(from: .init(
                    year: worktime.date.year,
                    month: worktime.date.month,
                    day: 1
                )) ?? worktime.date
            }
        )
    }

    static var incomePerMonth: [(Date, Double)] {
        Array(
            worktimesByMonth
                .mapValues { $0.map(\.pay).reduce(0, +) }
                .sorted { $0.key < $1.key }
                .prefix(12)
        )
    }

    static var previews: some View {
        InteractiveDateChart(data: incomePerMonth, graphType: .income)
            .environmentObject(Config())
    }
}
