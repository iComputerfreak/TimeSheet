// Copyright © 2025 Jonas Frey. All rights reserved.

@testable import Presentation

import Core
import Domain
import Foundation
import Model
import Testing

@MainActor
@Suite(.tags(.snapshot))
struct CreatePayoutSnapshotTests {
    private let exampleDate = Date(timeIntervalSince1970: 1735689600) // 2025-01-01

    @Injected private var userData: UserData

    init() {
        setupTesting()
        userData.worktimes = SampleData.screenshotWorktimes
    }

    @Test func testFullPayoutMode() {
        let viewModel = CreatePayoutView.ViewModel(
            fullPayoutMode: true,
            payoutDate: exampleDate
        )
        assertSnapshot {
            CreatePayoutView(viewModel: viewModel)
        }
    }

    @Test func testPartialPayoutMode() {
        let viewModel = CreatePayoutView.ViewModel(
            fullPayoutMode: false,
            payoutDate: exampleDate
        )
        assertSnapshot {
            CreatePayoutView(viewModel: viewModel)
        }
    }
}
