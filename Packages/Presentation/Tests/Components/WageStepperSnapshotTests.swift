// Copyright © 2025 Jonas Frey. All rights reserved.

@testable import Presentation

import Testing

@MainActor
@Suite(.tags(.snapshot))
struct WageStepperSnapshotTests {
    init() {
        registerTestingDependencies()
    }

    @Test(.serialized, arguments: [-100, -10.5, -12, -9, -0.5, 0, 0.5, 9, 10.5, 100])
    func testWageStepper(value: Double) {
        assertSnapshot(height: 50) {
            WageStepper(wage: .constant(value))
        }
    }
}
