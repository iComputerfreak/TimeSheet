// Copyright © 2025 Jonas Frey. All rights reserved.

@testable import Model

import Foundation
import Testing

@Suite
struct PayoutTests {
    @Test
    func testInitWithWorkTimes() {
        let workTimes = [
            WorkTime(date: Date(), activity: "A", hours: 1, minutes: 30, wage: 10),
            WorkTime(date: Date(), activity: "B", hours: 2, minutes: 0, wage: 15)
        ]
        let date = Date()
        let payout = Payout(date: date, workTimes: workTimes)

        #expect(payout.date == date)
        #expect(payout.workTimes.count == 2)
    }

    @Test
    func testDurationSum() {
        let workTimes = [
            WorkTime(date: Date(), activity: "A", hours: 1, minutes: 15, wage: 10),
            WorkTime(date: Date(), activity: "B", hours: 2, minutes: 45, wage: 15)
        ]
        let date = Date()
        let payout = Payout(date: date, workTimes: workTimes)
        let duration = payout.duration
        #expect(duration.hour == 3)
        #expect(duration.minute == 60)
    }

    @Test
    func testAmountSum() {
        let workTimes = [
            WorkTime(date: Date(), activity: "A", hours: 1, minutes: 0, wage: 10), // pay: 10
            WorkTime(date: Date(), activity: "B", hours: 2, minutes: 0, wage: 15)  // pay: 30
        ]
        let payout = Payout(date: Date(), workTimes: workTimes)
        #expect(payout.amount == 40)
    }

    @Test
    func testEmptyWorkTimes() {
        let payout = Payout(date: Date(), workTimes: [])
        #expect(payout.duration.hour == nil || payout.duration.hour == 0)
        #expect(payout.amount == 0)
    }
}
