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
struct AddWorkTimeTests {
    @Injected private var config: Config

    init() {
        registerTestingDependencies()
    }

    @Test func testDidAppearDateUnchanged() async {
        let sut: AddWorkTimeView.ViewModel = .init(worktimes: .constant([]))
        sut.date = Date().addingTimeInterval(-1 * .day)
        sut.dateChanged = false

        sut.didAppear()

        #expect(
            abs(sut.date.timeIntervalSinceNow) < 1.0,
            "The date should be updated to 'now', if the user did not modify it"
        )
        #expect(sut.wage == config.wage)
    }

    @Test func testDidAppearDateChanged() async {
        let sut: AddWorkTimeView.ViewModel = .init(worktimes: .constant([]))
        sut.dateChanged = true

        let dateBefore = Date().addingTimeInterval(-1 * .day)
        sut.date = dateBefore

        sut.didAppear()

        #expect(sut.date == dateBefore, "The date should remain unchanged if the user modified it.")
        #expect(sut.wage == config.wage)
    }

    @Test func testSaveEntryZeroHoursAndMinutes() {
        let sut: AddWorkTimeView.ViewModel = .init(worktimes: .constant([]))
        sut.date = Date()
        sut.activity = "Test Activity"
        sut.hours = 2
        sut.minutes = 30
        sut.wage = 20.0

        sut.hours = 0
        sut.minutes = 0

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
        let sut = AddWorkTimeView.ViewModel(worktimes: worktimesBinding)
        let newDate = Date()
        sut.date = newDate
        sut.activity = "Test Activity"
        sut.hours = 2
        sut.minutes = 30
        sut.wage = 20.0

        let worktimeCountBefore = worktimes.count

        sut.saveEntry()

        #expect(worktimes.count == worktimeCountBefore + 1)
        #expect(worktimes.last?.date == newDate)
        #expect(worktimes.last?.activity == "Test Activity")
        #expect(worktimes.last?.duration.hour == 2)
        #expect(worktimes.last?.duration.minute == 30)
        #expect(worktimes.last?.wage == 20.0)

        #expect(sut.dateChanged == false)
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
        let sut = AddWorkTimeView.ViewModel(editingItem: worktimeBinding)
        let newDate = Date()
        sut.date = newDate
        sut.activity = "Test Activity 2"
        sut.hours = 3
        sut.minutes = 20
        sut.wage = 22.0

        sut.saveEntry()

        #expect(worktime.date == newDate)
        #expect(worktime.activity == "Test Activity 2")
        #expect(worktime.duration.hour == 3)
        #expect(worktime.duration.minute == 20)
        #expect(worktime.wage == 22.0)

        #expect(sut.dateChanged == false)
    }

    @Test func testEmptyActivity() {
        var worktimes: [WorkTime] = []
        let worktimesBinding = Binding {
            worktimes
        } set: { newValue in
            worktimes = newValue
        }
        let sut = AddWorkTimeView.ViewModel(worktimes: worktimesBinding)
        let newDate = Date()
        sut.date = newDate
        sut.activity = ""
        sut.hours = 2
        sut.minutes = 30
        sut.wage = 20.0

        sut.saveEntry()

        #expect(worktimes.last?.activity == nil, "An empty activity text should result in a nil activity")
    }
}
