// Copyright © 2025 Jonas Frey. All rights reserved.

@testable import Presentation

import SwiftUI
import Testing

@MainActor
@Suite(.tags(.snapshot))
struct TimeViewSnapshotTests {
    init() {
        setupTesting()
    }

    @Test
    func testTimeView() {
        assertSnapshot(height: 800) {
            VStack(alignment: .leading, spacing: 8) {
                ForEach([-100, -10, -1, 0, 1, 10, 100], id: \.self) { hours in
                    ForEach([0, 30], id: \.self) { minutes in
                        ForEach([-10000.55, -100.3, -1, 0, 0.5, 1, 100.1, 10000.55], id: \.self) { amount in
                            let components = DateComponents(hour: hours, minute: minutes)
                            TimeView(duration: components, amount: amount)
                        }
                    }
                }
            }
        }
    }
}
