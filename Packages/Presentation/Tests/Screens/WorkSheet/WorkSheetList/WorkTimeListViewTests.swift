// Copyright © 2025 Jonas Frey. All rights reserved.

@testable import Presentation

import Core
import Domain
import Foundation
import Model
import SwiftUI
import Testing

@MainActor
@Suite(.tags(.unit), .serialized)
final class WorkTimeListViewTests {
    @Injected private var userData: UserData

    let sut: WorkTimeListView.ViewModel = .init(
        navigationTitle: "",
        worktimes: [],
        canEditWorktimes: true,
        canDeleteWorktimes: true
    )

    init() {
        setupTesting()
    }

    @Test func testWorkTimes() async {
        userData.worktimes = SampleData.screenshotWorktimes
        sut.worktimes = SampleData.screenshotWorktimes

        #expect(sut.years == [2023, 2022])
        #expect(sut.months(in: 2023) == [1])
        #expect(sut.months(in: 2022) == [12, 11])
        #expect(sut.worktimes == userData.worktimes)
        #expect(
            sut.worktimes(in: 2023, month: 1) == [SampleData.screenshotWorktimes[5]]
        )
        #expect(
            sut.worktimes(in: 2022, month: 12) == [4, 3].map { SampleData.screenshotWorktimes[$0] }
        )
        #expect(
            sut.worktimes(in: 2022, month: 11) == [2, 1, 0].map { SampleData.screenshotWorktimes[$0] }
        )
    }

    @Test func testDelete() {
        let worktime = SampleData.generateWorkTimes(count: 1).first!
        // We expect the worktime being deleted from the user data
        userData.worktimes = [worktime]
        #expect(userData.worktimes == [worktime])
        sut.delete(worktime)
        #expect(userData.worktimes.isEmpty)
    }

    @Test func testDeleteNonexistent() {
        let worktime = SampleData.generateWorkTimes(count: 1).first!
        sut.worktimes = [worktime]
        #expect(sut.worktimes == [worktime])
        // Delete invalid worktime
        sut.delete(SampleData.generateWorkTimes(count: 1).first!)
        #expect(sut.worktimes == [worktime])
    }

    @Test func testIsShowingEditButton() {
        let fixedPayWorktime = WorkTime(date: .now, activity: nil, fixedPay: 100)
        #expect(sut.isShowingEditButton(for: fixedPayWorktime) == false)
        let nonFixedPayWorktime = WorkTime(date: .now, activity: nil, duration: .init(hour: 1), wage: 10)
        #expect(sut.isShowingEditButton(for: nonFixedPayWorktime) == true)
    }

    @Test func testWorktimeBinding() {
        let worktime = SampleData.generateWorkTimes(count: 1).first!
        sut.worktimes = [worktime]

        #expect(sut.worktimeBinding(for: worktime.id).wrappedValue == worktime)
    }

    @Test func testHeaderString() {
        #expect(sut.headerString(year: 2025, month: 1) == "January 2025")
        #expect(sut.headerString(year: 2025, month: 2) == "February 2025")
        #expect(sut.headerString(year: 2025, month: 3) == "March 2025")
        #expect(sut.headerString(year: 2025, month: 4) == "April 2025")
        #expect(sut.headerString(year: 2025, month: 5) == "May 2025")
        #expect(sut.headerString(year: 2025, month: 6) == "June 2025")
        #expect(sut.headerString(year: 2025, month: 7) == "July 2025")
        #expect(sut.headerString(year: 2025, month: 8) == "August 2025")
        #expect(sut.headerString(year: 2025, month: 9) == "September 2025")
        #expect(sut.headerString(year: 2025, month: 10) == "October 2025")
        #expect(sut.headerString(year: 2025, month: 11) == "November 2025")
        #expect(sut.headerString(year: 2025, month: 12) == "December 2025")
    }

    @Test func testTotalHoursNoEntries() {
        #expect(sut.totalHours(in: 2025, month: 1) == .zero)
    }

    @Test func testTotalHoursSingleEntry() {
        let worktime = SampleData.generateWorkTimes(count: 1).first!
        sut.worktimes = [worktime]

        #expect(sut.totalHours(in: worktime.date.year, month: worktime.date.month).hour == worktime.duration.hour)
        #expect(sut.totalHours(in: worktime.date.year, month: worktime.date.month).minute == worktime.duration.minute)
        #expect(sut.totalHours(in: worktime.date.year + 1, month: worktime.date.month) == .zero)
        #expect(sut.totalHours(in: worktime.date.year, month: worktime.date.month + 1 % 12) == .zero)
    }

    @Test func testTotalHoursSingleEntryFixedPay() {
        let worktime = WorkTime(date: .now, activity: nil, fixedPay: 100)
        sut.worktimes = [worktime]

        // Fixed pay should not count towards total hours
        #expect(sut.totalHours(in: worktime.date.year, month: worktime.date.month) == .zero)
        #expect(sut.totalHours(in: worktime.date.year + 1, month: worktime.date.month) == .zero)
        #expect(sut.totalHours(in: worktime.date.year, month: worktime.date.month + 1 % 12) == .zero)
    }

    @Test func testTotalHoursMultipleEntry() {
        let worktime1 = SampleData.generateWorkTimes(count: 1).first!
        let worktime2 = WorkTime(date: worktime1.date, activity: nil, hours: 1, minutes: 30, wage: 10)
        sut.worktimes = [worktime1, worktime2]

        let totalDuration = worktime1.duration + worktime2.duration

        #expect(sut.totalHours(in: worktime1.date.year, month: worktime1.date.month) == totalDuration)
        #expect(sut.totalHours(in: worktime1.date.year + 1, month: worktime1.date.month) == .zero)
        #expect(sut.totalHours(in: worktime1.date.year, month: worktime1.date.month + 1 % 12) == .zero)
    }

    @Test func testTotalMoneyNoEntries() {
        #expect(sut.totalMoney(in: 2025, month: 1) == 0)
    }

    @Test func testTotalMoneySingleEntry() {
        let worktime = SampleData.generateWorkTimes(count: 1).first!
        sut.worktimes = [worktime]

        #expect(sut.totalMoney(in: worktime.date.year, month: worktime.date.month) == worktime.pay)
        #expect(sut.totalMoney(in: worktime.date.year + 1, month: worktime.date.month) == .zero)
        #expect(sut.totalMoney(in: worktime.date.year, month: worktime.date.month + 1 % 12) == .zero)
    }

    @Test func testTotalMoneyMultipleEntry() {
        let worktime1 = SampleData.generateWorkTimes(count: 1).first!
        let worktime2 = WorkTime(date: worktime1.date, activity: nil, hours: 1, minutes: 30, wage: 10)
        sut.worktimes = [worktime1, worktime2]

        let totalMoney = worktime1.pay + worktime2.pay

        #expect(sut.totalMoney(in: worktime1.date.year, month: worktime1.date.month) == totalMoney)
        #expect(sut.totalMoney(in: worktime1.date.year + 1, month: worktime1.date.month) == .zero)
        #expect(sut.totalMoney(in: worktime1.date.year, month: worktime1.date.month + 1 % 12) == .zero)
    }
}
