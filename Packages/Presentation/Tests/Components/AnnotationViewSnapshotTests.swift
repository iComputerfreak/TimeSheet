// Copyright © 2025 Jonas Frey. All rights reserved.

@testable import Presentation

import Model
import SwiftUI
import Testing
import XCTest

@MainActor
@Suite(.tags(.snapshot))
final class AnnotationViewSnapshotTests {
    init() {
        setupTesting()
    }

    @Test(.serialized, arguments: [
        (Date(timeIntervalSince1970: 1_000_000), 100.0, GraphType.income),
        (Date(timeIntervalSince1970: 1_000_000), 2.5, GraphType.time),
        (Date(timeIntervalSince1970: 1_000_000), 0.0, GraphType.income),
        (Date(timeIntervalSince1970: 1_000_000), 0.0, GraphType.time),
        (Date(timeIntervalSince1970: 1_000_000), -50.0, GraphType.income),
        (Date(timeIntervalSince1970: 1_000_000), 75.75, GraphType.time),
    ])
    func testAnnotationViewSnapshot(date: Date, value: Double, graphType: GraphType) async throws {
        assertSnapshot(height: 80) {
            AnnotationView(date: date, value: value, graphType: graphType)
                .padding()
        }
    }
}
