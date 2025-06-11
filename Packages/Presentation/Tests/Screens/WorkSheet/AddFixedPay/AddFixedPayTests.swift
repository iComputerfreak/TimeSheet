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
        registerTestingDependencies()
    }

    @Test func testInvertPayAmount() async {
        let sut: AddFixedPayView.ViewModel = .init(worktimes: .constant([]))

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
        let sut: AddFixedPayView.ViewModel = .init(worktimes: .constant([]))
        sut.date = Date()
        sut.activity = "Test Activity"
        sut.payAmount = 0

        sut.saveEntry()

        #expect(sut.zeroHoursShowing)
    }

    @Test func testSaveEntryCreation() {
        var worktimes: [WorkTime] = []
        let worktimesBinding = Binding {
            worktimes
        } set: { newValue in
            worktimes = newValue
        }
        let sut = AddFixedPayView.ViewModel(worktimes: worktimesBinding)
        let newDate = Date()
        sut.date = newDate
        sut.activity = "Test Activity"
        sut.payAmount = 25

        let worktimeCountBefore = worktimes.count

        sut.saveEntry()

        #expect(worktimes.count == worktimeCountBefore + 1)
        #expect(worktimes.last?.date == newDate)
        #expect(worktimes.last?.activity == "Test Activity")
        #expect(worktimes.last?.isFixedPay == true)
        #expect(worktimes.last?.pay == 25)
    }

    @Test func testSaveEntryEditing() {
        var worktime: WorkTime = .init(
            date: Date.distantPast,
            activity: "Test Activity",
            hours: 2,
            minutes: 30,
            wage: 20.0
        )
        let worktimeBinding = Binding {
            worktime
        } set: { newValue in
            worktime = newValue
        }
        let sut = AddFixedPayView.ViewModel(editingItem: worktimeBinding)
        let newDate = Date()
        sut.date = newDate
        sut.activity = "Test Activity 2"
        sut.payAmount = 22

        sut.saveEntry()

        #expect(worktime.date == newDate)
        #expect(worktime.activity == "Test Activity 2")
        #expect(worktime.isFixedPay == true)
        #expect(worktime.pay == 22)
    }

    @Test func testEmptyActivity() {
        var worktimes: [WorkTime] = []
        let worktimesBinding = Binding {
            worktimes
        } set: { newValue in
            worktimes = newValue
        }
        let sut = AddFixedPayView.ViewModel(worktimes: worktimesBinding)
        let newDate = Date()
        sut.date = newDate
        sut.activity = ""
        sut.payAmount = 22

        sut.saveEntry()

        #expect(worktimes.last?.activity == nil, "An empty activity text should result in a nil activity")
    }
}
