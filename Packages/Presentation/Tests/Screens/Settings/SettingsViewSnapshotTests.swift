// Copyright © 2025 Jonas Frey. All rights reserved.

@testable import Presentation

import Core
import Domain
import Foundation
import SnapshotTesting
import SnapshotTestingMacros
import Testing
import SwiftUI

@Suite
@MainActor
struct SettingsViewSnapshotTests {
    init() {
        registerTestingDependencies()
    }

    @Test
    func testSettings() async {
        await assertSnapshot {
            SettingsView()
        }
    }
}
