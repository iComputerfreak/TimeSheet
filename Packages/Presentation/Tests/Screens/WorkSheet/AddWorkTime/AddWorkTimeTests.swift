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
        setupTesting()
    }

    @Test func testDidAppearDateUnchanged() async {
        let sut: AddWorkTimeView.ViewModel = .init(workTimes: .constant([]))
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
        let sut: AddWorkTimeView.ViewModel = .init(workTimes: .constant([]))
        sut.dateChanged = true

        let dateBefore = Date().addingTimeInterval(-1 * .day)
        sut.date = dateBefore

        sut.didAppear()

        #expect(sut.date == dateBefore, "The date should remain unchanged if the user modified it.")
        #expect(sut.wage == config.wage)
    }

    @Test func testSaveEntryZeroHoursAndMinutes() {
        let sut: AddWorkTimeView.ViewModel = .init(workTimes: .constant([]))
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
        var workTimes: [WorkTime] = []
        let workTimesBinding = Binding {
            workTimes
        } set: { newValue in
            workTimes = newValue
        }
        let sut = AddWorkTimeView.ViewModel(workTimes: workTimesBinding)
        let newDate = Date()
        sut.date = newDate
        sut.activity = "Test Activity"
        sut.hours = 2
        sut.minutes = 30
        sut.wage = 20.0

        let workTimeCountBefore = workTimes.count

        sut.saveEntry()

        #expect(workTimes.count == workTimeCountBefore + 1)
        #expect(workTimes.last?.date == newDate)
        #expect(workTimes.last?.activity == "Test Activity")
        #expect(workTimes.last?.duration.hour == 2)
        #expect(workTimes.last?.duration.minute == 30)
        #expect(workTimes.last?.wage == 20.0)

        #expect(sut.dateChanged == false)
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
        let sut = AddWorkTimeView.ViewModel(editingItem: workTimeBinding)
        let newDate = Date()
        sut.date = newDate
        sut.activity = "Test Activity 2"
        sut.hours = 3
        sut.minutes = 20
        sut.wage = 22.0

        sut.saveEntry()

        #expect(workTime.date == newDate)
        #expect(workTime.activity == "Test Activity 2")
        #expect(workTime.duration.hour == 3)
        #expect(workTime.duration.minute == 20)
        #expect(workTime.wage == 22.0)

        #expect(sut.dateChanged == false)
    }

    @Test func testEmptyActivity() {
        var workTimes: [WorkTime] = []
        let workTimesBinding = Binding {
            workTimes
        } set: { newValue in
            workTimes = newValue
        }
        let sut = AddWorkTimeView.ViewModel(workTimes: workTimesBinding)
        let newDate = Date()
        sut.date = newDate
        sut.activity = ""
        sut.hours = 2
        sut.minutes = 30
        sut.wage = 20.0

        sut.saveEntry()

        #expect(workTimes.last?.activity == nil, "An empty activity text should result in a nil activity")
    }
}
