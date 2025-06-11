// Copyright © 2025 Jonas Frey. All rights reserved.

@testable import Presentation

import Core
import Foundation
import Model
import Testing

@MainActor
@Suite(.tags(.snapshot))
struct AddFixedPaySnapshotTests {
    init() {
        registerTestingDependencies()
    }

    @Test func testCreationEmpty() {
        assertSnapshot {
            AddFixedPayView(viewModel: .init(worktimes: .constant([])))
        }
    }

    @Test func testCreationFilled() {
        let viewModel = AddFixedPayView.ViewModel(worktimes: .constant([]))
        viewModel.activity = "Some Activity Name"
        viewModel.date = Date(timeIntervalSince1970: 1735689600) // 2025-01-01
        viewModel.payAmount = 22
        assertSnapshot {
            AddFixedPayView(viewModel: viewModel)
        }
    }

    @Test func testEditingFilled() {
        let workTime = WorkTime(
            date: Date(timeIntervalSince1970: 1735689600), // 2025-01-01
            activity: "Some Activity Name",
            fixedPay: 26.9
        )
        assertSnapshot(record: true) {
            AddFixedPayView(
                viewModel: .init(editingItem: .constant(workTime))
            )
        }
    }
}
