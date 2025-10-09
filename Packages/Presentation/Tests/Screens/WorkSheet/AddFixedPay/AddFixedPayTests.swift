// Copyright © 2025 Jonas Frey. All rights reserved.

@testable import Presentation

import Core
import Domain
import Foundation
import Model
import SwiftUI
import Testing

@MainActor
@Suite(.tags(.unit))
struct AddFixedPayTests {
    @Injected private var config: Config

    init() {
        setupTesting()
    }

    @Test func testInvertPayAmount() async {
        let sut: AddFixedPayView.ViewModel = .init(workTimes: .constant([]))

        sut.payAmount = 10
        sut.invertPayAmount()
        #expect(sut.payAmount == -10)

        sut.payAmount = -10
        sut.invertPayAmount()
        #expect(sut.payAmount == 10)

        sut.payAmount = 10
        sut.invertPayAmount()
        sut.invertPayAmount()
        #expect(sut.payAmount == 10)

        sut.payAmount = 0
        sut.invertPayAmount()
        #expect(sut.payAmount == 0)
    }

    @Test func testSaveEntryZeroAmount() {
        let sut: AddFixedPayView.ViewModel = .init(workTimes: .constant([]))
        sut.date = Date()
        sut.activity = "Test Activity"
        sut.payAmount = 0

        sut.saveEntry()

        #expect(sut.zeroHoursShowing)
    }

    @Test func testSaveEntryCreation() {
        var workTimes: [WorkTime] = []
        let workTimesBinding = Binding {
            workTimes
        } set: { newValue in
            workTimes = newValue
        }
        let sut = AddFixedPayView.ViewModel(workTimes: workTimesBinding)
        let newDate = Date()
        sut.date = newDate
        sut.activity = "Test Activity"
        sut.payAmount = 25

        let workTimeCountBefore = workTimes.count

        sut.saveEntry()

        #expect(workTimes.count == workTimeCountBefore + 1)
        #expect(workTimes.last?.date == newDate)
        #expect(workTimes.last?.activity == "Test Activity")
        #expect(workTimes.last?.isFixedPay == true)
        #expect(workTimes.last?.pay == 25)
    }

    @Test func testSaveEntryEditing() {
        var workTime: WorkTime = .init(
            date: Date.distantPast,
            activity: "Test Activity",
            hours: 2,
            minutes: 30,
            wage: 20.0
        )
        let workTimeBinding = Binding {
            workTime
        } set: { newValue in
            workTime = newValue
        }
        let sut = AddFixedPayView.ViewModel(editingItem: workTimeBinding)
        let newDate = Date()
        sut.date = newDate
        sut.activity = "Test Activity 2"
        sut.payAmount = 22

        sut.saveEntry()

        #expect(workTime.date == newDate)
        #expect(workTime.activity == "Test Activity 2")
        #expect(workTime.isFixedPay == true)
        #expect(workTime.pay == 22)
    }

    @Test func testEmptyActivity() {
        var workTimes: [WorkTime] = []
        let workTimesBinding = Binding {
            workTimes
        } set: { newValue in
            workTimes = newValue
        }
        let sut = AddFixedPayView.ViewModel(workTimes: workTimesBinding)
        let newDate = Date()
        sut.date = newDate
        sut.activity = ""
        sut.payAmount = 22

        sut.saveEntry()

        #expect(workTimes.last?.activity == nil, "An empty activity text should result in a nil activity")
    }
}
