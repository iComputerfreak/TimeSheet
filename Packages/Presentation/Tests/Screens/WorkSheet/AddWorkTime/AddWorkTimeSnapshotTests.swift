// Copyright © 2025 Jonas Frey. All rights reserved.

@testable import Presentation

import Core
import Foundation
import Model
import Testing

@MainActor
@Suite(.tags(.snapshot))
struct AddWorkTimeSnapshotTests {
    private let exampleDate = Date(timeIntervalSince1970: 1735689600) // 2025-01-01

    init() {
        registerTestingDependencies()
    }

    @Test func testCreationEmpty() {
        let viewModel = AddWorkTimeView.ViewModel(worktimes: .constant([]))
        // We need to set the date to a fixed value, otherwise it's "today", which will fail the snapshot test.
        viewModel.date = exampleDate
        viewModel.dateChanged = true
        assertSnapshot {
            AddWorkTimeView(viewModel: viewModel)
        }
    }

    @Test func testCreationFilled() {
        let viewModel = AddWorkTimeView.ViewModel(worktimes: .constant([]))
        viewModel.activity = "Some Activity Name"
        viewModel.date = exampleDate
        viewModel.hours = 4
        viewModel.minutes = 30
        viewModel.wage = 19.0
        assertSnapshot {
            AddWorkTimeView(viewModel: viewModel)
        }
    }

    @Test func testEditingFilled() {
        let workTime = WorkTime(
            date: exampleDate,
            activity: "Some Activity Name",
            hours: 4,
            minutes: 30,
            wage: 19.0
        )
        let viewModel = AddWorkTimeView.ViewModel(editingItem: .constant(workTime))
        // We need to set the date to a fixed value, otherwise it's "today", which will fail the snapshot test.
        viewModel.date = exampleDate
        assertSnapshot {
            AddWorkTimeView(
                viewModel: viewModel
            )
        }
    }
}
