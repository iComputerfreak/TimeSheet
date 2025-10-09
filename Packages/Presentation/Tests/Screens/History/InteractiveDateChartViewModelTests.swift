// Copyright © 2025 Jonas Frey. All rights reserved.

@testable import Presentation

import Foundation
import Model
import Testing

@MainActor
@Suite(.tags(.unit))
struct InteractiveDateChartViewModelTests {
    private let january = Date.fixed(year: 2024, month: 1, day: 1)
    private let february = Date.fixed(year: 2024, month: 2, day: 1)
    private let march = Date.fixed(year: 2024, month: 3, day: 1)

    init() {
        setupTesting()
    }

    @Test func testInitFillsMissingMonths() throws {
        // Missing Feb between Jan and Mar
        let viewModel = InteractiveDateChartView.ViewModel(data: [
            (january, 100),
            (march, 200)
        ], graphType: .income)

        print(viewModel.data)

        try #require(viewModel.data.count == 3)
        #expect(viewModel.data[0].0 == january)
        #expect(viewModel.data[0].1 == 100)

        // February should have been filled in with value 0
        #expect(viewModel.data[1].0 == february)
        #expect(viewModel.data[1].1 == 0)

        #expect(viewModel.data[2].0 == march)
        #expect(viewModel.data[2].1 == 200)
    }

    @Test func testDisplayedDataTruncatesTo12() {
        let months: [(Date, Double)] = (0..<16).map { offset in
            let date = Calendar.current.date(byAdding: .month, value: offset, to: january)!
            return (date, Double(offset))
        }
        let viewModel = InteractiveDateChartView.ViewModel(data: months, graphType: .income)
        #expect(viewModel.displayedData.count == 12)
        #expect(viewModel.displayedData.first?.1 == 4)
        #expect(viewModel.displayedData.last?.1 == 15)
    }

    @Test func testAlignmentForEdgesAndMiddle() {
        let months: [(Date, Double)] = (0..<3).map { offset in
            let date = Calendar.current.date(byAdding: .month, value: offset, to: january)!
            return (date, Double(offset))
        }
        let viewModel = InteractiveDateChartView.ViewModel(data: months, graphType: .income)
        let first = viewModel.displayedData.first!.0
        let last = viewModel.displayedData.last!.0
        let mid = viewModel.displayedData[1].0
        #expect(viewModel.alignment(for: first) == .topLeading)
        #expect(viewModel.alignment(for: last) == .topTrailing)
        #expect(viewModel.alignment(for: mid) == .top)
    }

    @Test func testNearestMonth() {
        let months: [(Date, Double)] = (0..<3).map { offset in
            let date = Calendar.current.date(byAdding: .month, value: offset, to: january)!
            return (date, Double(offset))
        }
        let viewModel = InteractiveDateChartView.ViewModel(data: months, graphType: .income)
        let beforeAll = Calendar.current.date(byAdding: .month, value: -1, to: january)!
        let afterAll = Calendar.current.date(byAdding: .month, value: 4, to: january)!
        #expect(viewModel.nearestMonth(to: beforeAll) == viewModel.displayedData.first?.0)
        #expect(viewModel.nearestMonth(to: afterAll) == viewModel.displayedData.last?.0)
        // In between the first and second month
        let between = Calendar.current.date(byAdding: .day, value: 20, to: viewModel.displayedData[0].0)!
        let expected = viewModel.displayedData[1].0
        #expect(viewModel.nearestMonth(to: between) == expected)
    }

    @Test func testEmptyData() {
        let viewModel = InteractiveDateChartView.ViewModel(data: [], graphType: .income)
        #expect(viewModel.data.isEmpty)
        #expect(viewModel.displayedData.isEmpty)
        let testDate = Date(timeIntervalSince1970: 1_000_000)
        #expect(viewModel.nearestMonth(to: testDate) == testDate)
    }
}
