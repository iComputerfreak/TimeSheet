// Copyright © 2025 Jonas Frey. All rights reserved.

@testable import Presentation

import Core
import Domain
import Foundation
import Model
import Testing

@MainActor
@Suite(.tags(.snapshot))
struct HistoryViewSnapshotTests {
    private let exampleDate = Date.fixed(year: 2025, month: 1, day: 1)

    @Injected private var userData: UserData

    init() {
        setupTesting()
    }

    @Test func testEmptyHistory() {
        let viewModel = HistoryView.ViewModel()
        // Ensure workTimes is empty for empty state
        userData.workTimes = []
        assertSnapshot {
            HistoryView(viewModel: viewModel)
        }
    }

    @Test func testFilledHistory() {
        let workTimes: [WorkTime] = [
            WorkTime(
                date: exampleDate,
                activity: "Consulting",
                hours: 5,
                minutes: 0,
                wage: 50.0
            ),
            WorkTime(
                date: exampleDate.addingTimeInterval(60 * 60 * 24 * 35), // Next month
                activity: "Development",
                hours: 3,
                minutes: 30,
                wage: 60.0
            ),
            WorkTime(
                date: exampleDate.addingTimeInterval(60 * 60 * 24 * 65), // Two months later
                activity: "Testing",
                hours: 2,
                minutes: 45,
                wage: 45.0
            )
        ]
        let viewModel = HistoryView.ViewModel()
        userData.workTimes = workTimes
        assertSnapshot {
            HistoryView(viewModel: viewModel)
        }
    }
}
