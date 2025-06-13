// Copyright © 2025 Jonas Frey. All rights reserved.

@testable import Presentation

import Core
import Foundation
import Model
import Testing

@MainActor
@Suite(.tags(.snapshot))
struct AddFixedPaySnapshotTests {
    private let exampleDate = Date(timeIntervalSince1970: 1735689600) // 2025-01-01

    init() {
        setupTesting()
    }

    @Test func testCreationEmpty() {
        let viewModel = AddFixedPayView.ViewModel(worktimes: .constant([]))
        // We need to set the date to a fixed value, otherwise it's "today", which will fail the snapshot test.
        viewModel.date = exampleDate
        assertSnapshot {
            AddFixedPayView(viewModel: viewModel)
        }
    }

    @Test func testCreationFilled() {
        let viewModel = AddFixedPayView.ViewModel(worktimes: .constant([]))
        viewModel.activity = "Some Activity Name"
        viewModel.date = exampleDate
        viewModel.payAmount = 22
        assertSnapshot {
            AddFixedPayView(viewModel: viewModel)
        }
    }

    @Test func testEditingFilled() {
        let workTime = WorkTime(
            date: exampleDate,
            activity: "Some Activity Name",
            fixedPay: 26.9
        )
        assertSnapshot {
            AddFixedPayView(
                viewModel: .init(editingItem: .constant(workTime))
            )
        }
    }
}
