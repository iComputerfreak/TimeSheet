// Copyright © 2025 Jonas Frey. All rights reserved.

import Charts
import Core
import Domain
import Model
import SwiftUI

extension HistoryView {
    @Observable
    public class ViewModel: ViewModelProtocol {
        static let historyDurationFormatter = DateComponentsFormatter(
            allowedUnits: [.hour, .minute],
            unitsStyle: .short
        )

        var graphType: GraphType = .income

        @ObservationIgnored @Injected private var config: Config
        @ObservationIgnored @Injected private var userData: UserData

        var currency: String { config.currency }

        var workTimes: [WorkTime] {
            userData.workTimes + userData.payouts.flatMap(\.workTimes)
        }

        var workTimesByMonth: [Date: [WorkTime]] {
            Dictionary(
                grouping: workTimes,
                by: { workTime in
                    Calendar.current.date(from: .init(
                        year: workTime.date.year,
                        month: workTime.date.month,
                        day: 1
                    )) ?? workTime.date
                }
            )
        }

        var incomePerMonth: [(Date, Double)] {
            workTimesByMonth
            // Do not include payouts
            // TODO: We should not compare the literal title here, we should create a different struct for Payouts
                .mapValues { value in
                    value
                        .filter { $0.activity != Strings.Payouts.activityText }
                        .map(\.pay)
                        .reduce(0, +)
                }
                .sorted { $0.key < $1.key }
        }

        var hoursPerMonth: [(Date, Double)] {
            var hoursByMonth: [(key: Date, value: Double)] = []
            for (date, workTimes) in workTimesByMonth {
                let hours = workTimes
                // Don't include fixed pay in the hours
                    .filter { !$0.isFixedPay }
                    .map(\.duration)
                    .map { (duration: DateComponents) -> Double in
                        Double(duration.hour ?? 0) + Double(duration.minute ?? 0) / 60
                    }
                    .reduce(0, +)
                hoursByMonth.append((date, hours))
            }

            return hoursByMonth.sorted { $0.key < $1.key }
        }

        var data: [(Date, Double)] {
            switch graphType {
            case .income:
                return incomePerMonth

            case .time:
                return hoursPerMonth
            }
        }

        public init() {}
    }
}
