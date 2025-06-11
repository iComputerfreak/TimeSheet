// Copyright © 2025 Jonas Frey. All rights reserved.

@testable import Model

import Foundation
import Testing

@Suite
struct PayoutTests {
    @Test
    func testInitWithWorktimes() {
        let worktimes = [
            WorkTime(date: Date(), activity: "A", hours: 1, minutes: 30, wage: 10),
            WorkTime(date: Date(), activity: "B", hours: 2, minutes: 0, wage: 15)
        ]
        let date = Date()
        let payout = Payout(date: date, worktimes: worktimes)

        #expect(payout.date == date)
        #expect(payout.worktimes.count == 2)
    }

    @Test
    func testDurationSum() {
        let worktimes = [
            WorkTime(date: Date(), activity: "A", hours: 1, minutes: 15, wage: 10),
            WorkTime(date: Date(), activity: "B", hours: 2, minutes: 45, wage: 15)
        ]
        let date = Date()
        let payout = Payout(date: date, worktimes: worktimes)
        let duration = payout.duration
        #expect(duration.hour == 3)
        #expect(duration.minute == 60)
    }

    @Test
    func testAmountSum() {
        let worktimes = [
            WorkTime(date: Date(), activity: "A", hours: 1, minutes: 0, wage: 10), // pay: 10
            WorkTime(date: Date(), activity: "B", hours: 2, minutes: 0, wage: 15)  // pay: 30
        ]
        let payout = Payout(date: Date(), worktimes: worktimes)
        #expect(payout.amount == 40)
    }

    @Test
    func testEmptyWorktimes() {
        let payout = Payout(date: Date(), worktimes: [])
        #expect(payout.duration.hour == nil || payout.duration.hour == 0)
        #expect(payout.amount == 0)
    }
}
