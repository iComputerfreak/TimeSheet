// Copyright © 2025 Jonas Frey. All rights reserved.

@testable import Presentation

import Core
import Domain
import Foundation
import Model
import Testing

@MainActor
@Suite(.tags(.unit))
struct HistoryViewModelTests {
    private let january = Date.fixed(year: 2025, month: 1, day: 1)
    private let february = Date.fixed(year: 2025, month: 2, day: 1)
    private let march = Date.fixed(year: 2025, month: 3, day: 1)

    @Injected private var userData: UserData

    init() {
        setupTesting()
    }

    @Test func testEmptyWorktimes() {
        userData.worktimes = []
        let viewModel = HistoryView.ViewModel()
        #expect(viewModel.worktimes.isEmpty)
        #expect(viewModel.worktimesByMonth.isEmpty)
        #expect(viewModel.incomePerMonth.isEmpty)
        #expect(viewModel.hoursPerMonth.isEmpty)
        #expect(viewModel.data.isEmpty)
    }

    @Test func testSingleWorktimeIncomeAndHours() {
        let wt = WorkTime(date: january, activity: "Consulting", hours: 2, minutes: 30, wage: 50.0)
        userData.worktimes = [wt]
        let viewModel = HistoryView.ViewModel()

        // worktimes
        #expect(viewModel.worktimes == [wt])
        // by month
        #expect(viewModel.worktimesByMonth[january]?.first == wt)
        // income
        #expect(viewModel.incomePerMonth.contains(where: { $0.0 == january && $0.1 == wt.pay }))
        // hours
        #expect(viewModel.hoursPerMonth.contains(where: { $0.0 == january && $0.1 == 2.5 }))
        // data (default graphType == .income)
        #expect(viewModel.data.map(\.0) == viewModel.incomePerMonth.map(\.0))
        #expect(viewModel.data.map(\.1) == viewModel.incomePerMonth.map(\.1))
    }

    @Test func testMultipleMonths() {
        let wt1 = WorkTime(date: january, activity: "A", hours: 2, minutes: 0, wage: 40)
        let wt2 = WorkTime(date: february, activity: "B", hours: 3, minutes: 30, wage: 50)
        let wt3 = WorkTime(date: march, activity: "C", hours: 1, minutes: 45, wage: 55)
        userData.worktimes = [wt1, wt2, wt3]

        let viewModel = HistoryView.ViewModel()

        #expect(viewModel.worktimes.count == 3)
        #expect(viewModel.worktimesByMonth.count == 3)
        #expect(viewModel.incomePerMonth.count == 3)
        #expect(viewModel.hoursPerMonth.count == 3)
        // Data is income by default
        #expect(viewModel.data[0].1 == wt1.pay)
        #expect(viewModel.data[1].1 == wt2.pay)
        #expect(viewModel.data[2].1 == wt3.pay)
    }

    @Test func testGraphTypeSwitch() {
        let wt = WorkTime(date: january, activity: "Consulting", hours: 2, minutes: 30, wage: 50.0)
        userData.worktimes = [wt]
        let viewModel = HistoryView.ViewModel()

        // Default is income
        #expect(viewModel.graphType == .income)
        #expect(viewModel.data.map(\.0) == viewModel.incomePerMonth.map(\.0))
        #expect(viewModel.data.map(\.1) == viewModel.incomePerMonth.map(\.1))

        // Switch to .time
        viewModel.graphType = .time
        #expect(viewModel.data.map(\.0) == viewModel.hoursPerMonth.map(\.0))
        #expect(viewModel.data.map(\.1) == viewModel.hoursPerMonth.map(\.1))
    }

    @Test func testCurrency() {
        let viewModel = HistoryView.ViewModel()
        let expectedCurrency = viewModel.currency
        #expect(viewModel.currency == expectedCurrency)
    }

    @Test func testHistoryDurationFormatter() {
        let comps = DateComponents(hour: 2, minute: 45)
        let formatted = HistoryView.ViewModel.historyDurationFormatter.string(from: comps)
        #expect(formatted?.contains("2") == true)
        #expect(formatted?.contains("45") == true)
    }
}
