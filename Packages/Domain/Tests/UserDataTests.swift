@testable import Domain

import Foundation
import Model
import Testing

@Suite
struct UserDataTests {
    @Test("Init with sample data computes correct totals")
    func testInitWithSampleData() {
        let date = Date()
        // Create two WorkTime entries:
        // one regular (2h @ $20), one fixed pay ($50)
        let regularWorktime = WorkTime(date: date, activity: "Regular Work", hours: 2, minutes: 0, wage: 20)
        let fixedPayWorktime = WorkTime(date: date, activity: "Fixed Pay Work", fixedPay: 50)

        // One Payout including both worktimes
        let payout = Payout(id: UUID(), date: date, worktimes: [regularWorktime, fixedPayWorktime])

        // Initialize FileUserData with these
        let userData = FileUserData(worktimes: [regularWorktime, fixedPayWorktime], payouts: [payout])

        // totalWorkingDuration only includes the regular one (2h)
        #expect(userData.totalWorkingDuration.hour == 2)
        #expect(userData.totalWorkingDuration.minute == 0)

        // totalWorktimePayIncludingDebts includes both: (2 * 20) + 50 = 90
        #expect(userData.totalWorktimePayIncludingDebts == 90)

        // worktimes and payouts are assigned as expected
        #expect(userData.worktimes.count == 2)
        #expect(userData.payouts.count == 1)

        #expect(userData.worktimes.contains(where: { $0.activity == "Regular Work" }) == true)
        #expect(userData.worktimes.contains(where: { $0.activity == "Fixed Pay Work" }) == true)

        #expect(userData.payouts.contains(where: { $0.id == payout.id }) == true)
    }

    @Test("Init with only zero-pay worktimes")
    func testInitWithZeroPayWorktimes() {
        let date = Date()
        // Two worktimes with pay == 0
        let zeroPayWorktime1 = WorkTime(date: date, activity: "Zero Pay 1", hours: 1, minutes: 0, wage: 0)
        let zeroPayWorktime2 = WorkTime(date: date, activity: "Zero Pay 2", hours: 3, minutes: 0, wage: 0)

        let userData = FileUserData(worktimes: [zeroPayWorktime1, zeroPayWorktime2], payouts: [])

        // totalWorkingDuration should be zero because pay is zero
        #expect(userData.totalWorkingDuration.hour == 0)
        #expect(userData.totalWorkingDuration.minute == 0)

        // totalWorktimePayIncludingDebts should be zero
        #expect(userData.totalWorktimePayIncludingDebts == 0)
    }

    @Test("Init with only fixed pay worktimes")
    func testInitWithOnlyFixedPayWorktimes() {
        let date = Date()
        // Worktimes all fixed pay
        let fixedPay1 = WorkTime(date: date, activity: "Fixed Pay 1", fixedPay: 60)
        let fixedPay2 = WorkTime(date: date, activity: "Fixed Pay 2", fixedPay: 40)

        let userData = FileUserData(worktimes: [fixedPay1, fixedPay2], payouts: [])

        // totalWorkingDuration should be zero (per filter in implementation)
        #expect(userData.totalWorkingDuration.hour == 0)
        #expect(userData.totalWorkingDuration.minute == 0)

        // totalWorktimePayIncludingDebts should equal the sum of fixed pays (60 + 40 = 100)
        #expect(userData.totalWorktimePayIncludingDebts == 100)
    }

    @Test("Init with no data")
    func testInitWithNoData() {
        // FileUserData with empty arrays
        let userData = FileUserData(worktimes: [], payouts: [])

        // totalWorkingDuration should be zero
        #expect(userData.totalWorkingDuration.hour == 0)
        #expect(userData.totalWorkingDuration.minute == 0)

        // totalWorktimePayIncludingDebts should be zero
        #expect(userData.totalWorktimePayIncludingDebts == 0)

        // worktimes and payouts empty
        #expect(userData.worktimes.count == 0)
        #expect(userData.payouts.count == 0)
    }
}
