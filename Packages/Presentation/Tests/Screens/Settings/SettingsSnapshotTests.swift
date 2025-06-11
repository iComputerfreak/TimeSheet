// Copyright © 2025 Jonas Frey. All rights reserved.

@testable import Presentation

import Testing

@MainActor
@Suite(.tags(.snapshot))
struct SettingsViewSnapshotTests {
    init() {
        registerTestingDependencies()
    }

    @Test
    func testSettings() {
        assertSnapshot {
            SettingsView()
        }
    }
}
