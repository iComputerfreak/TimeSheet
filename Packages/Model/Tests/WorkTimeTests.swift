// Copyright © 2025 Jonas Frey. All rights reserved.

import Foundation
import Testing
@testable import Model

@Suite
struct WorkTimeTests {
    @Test
    func testInitWithDuration() {
        let date = Date()
        let duration = DateComponents(hour: 2, minute: 30)
        let workTime = WorkTime(date: date, activity: "Test", duration: duration, wage: 15.0)

        #expect(workTime.date == date)
        #expect(workTime.activity == "Test")
        #expect(workTime.duration.hour == 2)
        #expect(workTime.duration.minute == 30)
        #expect(workTime.wage == 15.0)
        #expect(workTime.isFixedPay == false)
    }

    @Test
    func testInitWithHoursAndMinutes() {
        let date = Date()
        let workTime = WorkTime(date: date, activity: "Test", hours: 3, minutes: 45, wage: 20.0)

        #expect(workTime.date == date)
        #expect(workTime.activity == "Test")
        #expect(workTime.duration.hour == 3)
        #expect(workTime.duration.minute == 45)
        #expect(workTime.wage == 20.0)
        #expect(workTime.isFixedPay == false)
    }

    @Test
    func testInitWithFixedPay() {
        let date = Date()
        let workTime = WorkTime(date: date, activity: "Bonus", fixedPay: 100.0)

        #expect(workTime.date == date)
        #expect(workTime.activity == "Bonus")
        #expect(workTime.duration.hour == 1)
        #expect(workTime.duration.minute == 0)
        #expect(workTime.wage == 100.0)
        #expect(workTime.isFixedPay == true)
    }

    @Test
    func testPayCalculation() {
        let workTime = WorkTime(date: Date(), activity: "Test", hours: 2, minutes: 30, wage: 20.0)
        // 2.5 hours × $20 = $50
        #expect(workTime.pay == 50.0)
    }

    @Test
    func testPayCalculationWithZeroDuration() {
        let workTime = WorkTime(date: Date(), activity: "Test", hours: 0, minutes: 0, wage: 15.0)
        #expect(workTime.pay == 0.0)
    }

    @Test
    func testFixedPayCalculation() {
        let workTime = WorkTime(date: Date(), activity: "Bonus", fixedPay: 100.0)
        #expect(workTime.pay == 100.0)
    }

    @Test
    func testDateComponentsPayExtension() {
        let duration = DateComponents(hour: 3, minute: 15)
        let pay = duration.pay(using: 10.0)
        // 3.25 hours × $10 = $32.5
        #expect(pay == 32.5)
    }

    @Test
    func testNilActivityHandling() {
        let workTime = WorkTime(date: Date(), activity: nil, hours: 2, minutes: 0, wage: 15.0)
        #expect(workTime.activity == nil)
    }

    @Test
    func testDurationFormatter() {
        let formatter = WorkTime.durationFormatter
        let duration = DateComponents(hour: 1, minute: 30)
        let formatted = formatter.string(from: duration)
        #expect(formatted?.contains("1h") == true)
        #expect(formatted?.contains("30m") == true)
    }

    @Test
    func testEquality() {
        let date = Date()
        let workTime1 = WorkTime(date: date, activity: "Test", hours: 2, minutes: 30, wage: 15.0)
        let workTime2 = WorkTime(date: date, activity: "Test", hours: 2, minutes: 30, wage: 15.0)
        let workTime3 = WorkTime(date: date, activity: "Different", hours: 2, minutes: 30, wage: 15.0)

        // Different instances with same values should be equal except for the id
        #expect(workTime1.date == workTime2.date)
        #expect(workTime1.activity == workTime2.activity)
        #expect(workTime1.duration == workTime2.duration)
        #expect(workTime1.wage == workTime2.wage)
        #expect(workTime1.id != workTime2.id)

        // Different activity
        #expect(workTime1.activity != workTime3.activity)
    }
}
