// Copyright © 2025 Jonas Frey. All rights reserved.

@testable import Presentation

import Model
import SwiftUI
import Testing

@MainActor
@Suite(.tags(.snapshot))
struct InteractiveDateChartViewSnapshotTests {
    init() {
        setupTesting()
    }

    @Test(.serialized, arguments: [
        // Income chart example (simple data)
        (graphType: GraphType.income, data: [
            (Date(timeIntervalSince1970: 1_000_000), 100.0),
            (Date(timeIntervalSince1970: 2_000_000), 250.0),
            (Date(timeIntervalSince1970: 3_000_000), 400.0),
            (Date(timeIntervalSince1970: 4_000_000), 300.0),
            (Date(timeIntervalSince1970: 5_000_000), 800.0)
        ]),
        // Time chart example (hours worked)
        (graphType: GraphType.time, data: [
            (Date(timeIntervalSince1970: 1_000_000), 2.5),
            (Date(timeIntervalSince1970: 2_000_000), 3.75),
            (Date(timeIntervalSince1970: 3_000_000), 8.0)
        ]),
        // Empty data
        (graphType: GraphType.income, data: []),
        // Edge case: large values
        (graphType: GraphType.income, data: [
            (Date(timeIntervalSince1970: 1_000_000), 10_000_000.0),
            (Date(timeIntervalSince1970: 2_000_000), 15_000_000.0),
            (Date(timeIntervalSince1970: 3_000_000), 8_000_000.0)
        ]),
        // Edge case: negative (debt) values
        (graphType: GraphType.income, data: [
            (Date(timeIntervalSince1970: 1_000_000), -150.0),
            (Date(timeIntervalSince1970: 2_000_000), -1_000.0),
            (Date(timeIntervalSince1970: 3_000_000), -1_200.0)
        ])
    ])

    func testInteractiveDateChartView(graphType: GraphType, data: [(Date, Double)]) {
        let viewModel = InteractiveDateChartView.ViewModel(data: data, graphType: graphType)
        assertSnapshot(height: 400) {
            InteractiveDateChartView(viewModel: viewModel)
                .padding()
        }
    }
}
