// Copyright © 2025 Jonas Frey. All rights reserved.

@testable import Presentation

import Core
import Domain
import Foundation
import Model
import Testing

@MainActor
@Suite(.tags(.snapshot))
struct EditPayoutSnapshotTests {
    @Injected private var userData: UserData

    init() {
        setupTesting()
        userData.worktimes = SampleData.screenshotWorktimes
    }

    @Test func testEditPayout() {
        let viewModel = EditPayoutView.ViewModel(payout: .constant(SampleData.screenshotPayouts.first!))
        assertSnapshot {
            EditPayoutView(viewModel: viewModel)
        }
    }
}
