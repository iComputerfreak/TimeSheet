// Copyright © 2025 Jonas Frey. All rights reserved.

@testable import Presentation

import Core
import Domain
import Foundation
import Model
import Testing

@MainActor
@Suite(.tags(.snapshot))
struct PayoutsSnapshotTests {
    @Injected private var userData: UserData

    init() {
        setupTesting()
    }

    @Test func testPayoutsEmptyView() {
        let viewModel = PayoutsView.ViewModel()
        assertSnapshot {
            PayoutsView(viewModel: viewModel)
        }
    }

    @Test func testPayoutsView() {
        userData.payouts = SampleData.screenshotPayouts
        let viewModel = PayoutsView.ViewModel()
        assertSnapshot {
            PayoutsView(viewModel: viewModel)
        }
    }
}
