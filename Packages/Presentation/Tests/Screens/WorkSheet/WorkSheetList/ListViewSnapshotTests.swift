// Copyright © 2025 Jonas Frey. All rights reserved.

@testable import Presentation

import Core
import Domain
import Foundation
import Model
import Testing

@MainActor
@Suite(.tags(.snapshot))
struct ListViewSnapshotTests {
    @Injected private var userData: UserData

    init() {
        setupTesting()
    }

    @Test func testEmpty() {
        assertSnapshot {
            ListView()
        }
    }

    @Test func testFilled() {
        userData.worktimes = SampleData.screenshotWorktimes
        assertSnapshot {
            ListView()
        }
    }
}
