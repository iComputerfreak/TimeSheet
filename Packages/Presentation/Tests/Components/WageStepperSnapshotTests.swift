// Copyright © 2025 Jonas Frey. All rights reserved.

@testable import Presentation

import SwiftUI
import Testing

@MainActor
@Suite(.tags(.snapshot))
struct WageStepperSnapshotTests {
    init() {
        registerTestingDependencies()
    }

    @Test
    func testWageStepper() {
        assertSnapshot(height: 400) {
            VStack(alignment: .leading, spacing: 8) {
                ForEach([-100, -10.5, -12, -9, -0.5, 0, 0.5, 9, 10.5, 100], id: \.self) { value in
                    WageStepper(wage: .constant(value))
                }
            }
        }
    }
}
