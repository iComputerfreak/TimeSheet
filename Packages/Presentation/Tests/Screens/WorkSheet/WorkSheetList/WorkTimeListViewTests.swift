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
        workTimes: [],
        canEditWorkTimes: true,
        canDeleteWorkTimes: true
    )

    init() {
        setupTesting()
    }

    @Test func testWorkTimes() async {
        userData.workTimes = SampleData.screenshotWorkTimes
        sut.workTimes = SampleData.screenshotWorkTimes

        #expect(sut.years == [2023, 2022])
        #expect(sut.months(in: 2023) == [1])
        #expect(sut.months(in: 2022) == [12, 11])
        #expect(sut.workTimes == userData.workTimes)
        #expect(
            sut.workTimes(in: 2023, month: 1) == [SampleData.screenshotWorkTimes[5]]
        )
        #expect(
            sut.workTimes(in: 2022, month: 12) == [4, 3].map { SampleData.screenshotWorkTimes[$0] }
        )
        #expect(
            sut.workTimes(in: 2022, month: 11) == [2, 1, 0].map { SampleData.screenshotWorkTimes[$0] }
        )
    }

    @Test func testDelete() {
        let workTime = SampleData.generateWorkTimes(count: 1).first!
        // We expect the workTime being deleted from the user data
        userData.workTimes = [workTime]
        #expect(userData.workTimes == [workTime])
        sut.delete(workTime)
        #expect(userData.workTimes.isEmpty)
    }

    @Test func testDeleteNonexistent() {
        let workTime = SampleData.generateWorkTimes(count: 1).first!
        sut.workTimes = [workTime]
        #expect(sut.workTimes == [workTime])
        // Delete invalid workTime
        sut.delete(SampleData.generateWorkTimes(count: 1).first!)
        #expect(sut.workTimes == [workTime])
    }

    @Test func testIsShowingEditButton() {
        let fixedPayWorkTime = WorkTime(date: .now, activity: nil, fixedPay: 100)
        #expect(sut.isShowingEditButton(for: fixedPayWorkTime) == false)
        let nonFixedPayWorkTime = WorkTime(date: .now, activity: nil, duration: .init(hour: 1), wage: 10)
        #expect(sut.isShowingEditButton(for: nonFixedPayWorkTime) == true)
    }

    @Test func testWorkTimeBinding() {
        let workTime = SampleData.generateWorkTimes(count: 1).first!
        sut.workTimes = [workTime]

        #expect(sut.workTimeBinding(for: workTime.id).wrappedValue == workTime)
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
        let workTime = SampleData.generateWorkTimes(count: 1).first!
        sut.workTimes = [workTime]

        #expect(sut.totalHours(in: workTime.date.year, month: workTime.date.month).hour == workTime.duration.hour)
        #expect(sut.totalHours(in: workTime.date.year, month: workTime.date.month).minute == workTime.duration.minute)
        #expect(sut.totalHours(in: workTime.date.year + 1, month: workTime.date.month) == .zero)
        #expect(sut.totalHours(in: workTime.date.year, month: workTime.date.month + 1 % 12) == .zero)
    }

    @Test func testTotalHoursSingleEntryFixedPay() {
        let workTime = WorkTime(date: .now, activity: nil, fixedPay: 100)
        sut.workTimes = [workTime]

        // Fixed pay should not count towards total hours
        #expect(sut.totalHours(in: workTime.date.year, month: workTime.date.month) == .zero)
        #expect(sut.totalHours(in: workTime.date.year + 1, month: workTime.date.month) == .zero)
        #expect(sut.totalHours(in: workTime.date.year, month: workTime.date.month + 1 % 12) == .zero)
    }

    @Test func testTotalHoursMultipleEntry() {
        let workTime1 = SampleData.generateWorkTimes(count: 1).first!
        let workTime2 = WorkTime(date: workTime1.date, activity: nil, hours: 1, minutes: 30, wage: 10)
        sut.workTimes = [workTime1, workTime2]

        let totalDuration = workTime1.duration + workTime2.duration

        #expect(sut.totalHours(in: workTime1.date.year, month: workTime1.date.month) == totalDuration)
        #expect(sut.totalHours(in: workTime1.date.year + 1, month: workTime1.date.month) == .zero)
        #expect(sut.totalHours(in: workTime1.date.year, month: workTime1.date.month + 1 % 12) == .zero)
    }

    @Test func testTotalMoneyNoEntries() {
        #expect(sut.totalMoney(in: 2025, month: 1) == 0)
    }

    @Test func testTotalMoneySingleEntry() {
        let workTime = SampleData.generateWorkTimes(count: 1).first!
        sut.workTimes = [workTime]

        #expect(sut.totalMoney(in: workTime.date.year, month: workTime.date.month) == workTime.pay)
        #expect(sut.totalMoney(in: workTime.date.year + 1, month: workTime.date.month) == .zero)
        #expect(sut.totalMoney(in: workTime.date.year, month: workTime.date.month + 1 % 12) == .zero)
    }

    @Test func testTotalMoneyMultipleEntry() {
        let workTime1 = SampleData.generateWorkTimes(count: 1).first!
        let workTime2 = WorkTime(date: workTime1.date, activity: nil, hours: 1, minutes: 30, wage: 10)
        sut.workTimes = [workTime1, workTime2]

        let totalMoney = workTime1.pay + workTime2.pay

        #expect(sut.totalMoney(in: workTime1.date.year, month: workTime1.date.month) == totalMoney)
        #expect(sut.totalMoney(in: workTime1.date.year + 1, month: workTime1.date.month) == .zero)
        #expect(sut.totalMoney(in: workTime1.date.year, month: workTime1.date.month + 1 % 12) == .zero)
    }
}
