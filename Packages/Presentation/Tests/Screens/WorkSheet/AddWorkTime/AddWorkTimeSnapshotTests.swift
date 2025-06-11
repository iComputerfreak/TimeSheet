// Copyright © 2025 Jonas Frey. All rights reserved.

@testable import Presentation

import Core
import Foundation
import Model
import Testing

@MainActor
@Suite(.tags(.snapshot))
struct AddWorkTimeSnapshotTests {
    init() {
        registerTestingDependencies()
    }

    @Test func testCreationEmpty() {
        assertSnapshot {
            AddWorkTimeView(viewModel: .init(worktimes: .constant([])))
        }
    }

    @Test func testCreationFilled() {
        let viewModel = AddWorkTimeView.ViewModel(worktimes: .constant([]))
        viewModel.activity = "Some Activity Name"
        viewModel.date = Date(timeIntervalSince1970: 1735689600) // 2025-01-01
        viewModel.hours = 4
        viewModel.minutes = 30
        viewModel.wage = 19.0
        assertSnapshot {
            AddWorkTimeView(viewModel: viewModel)
        }
    }

    @Test func testEditingFilled() {
        let workTime = WorkTime(
            date: Date(timeIntervalSince1970: 1735689600), // 2025-01-01
            activity: "Some Activity Name",
            hours: 4,
            minutes: 30,
            wage: 19.0
        )
        assertSnapshot {
            AddWorkTimeView(
                viewModel: .init(editingItem: .constant(workTime))
            )
        }
    }
}
