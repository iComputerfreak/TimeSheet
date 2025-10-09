@testable import Domain

import Core
import Foundation
import Model
import Testing

@Suite
final class UserDataTests {
    init() {
        setupTesting()
    }

    @Test("Init with sample data computes correct totals")
    func testInitWithSampleData() {
        let date = Date()
        // Create two WorkTime entries:
        // one regular (2h @ $20), one fixed pay ($50)
        let regularWorkTime = WorkTime(date: date, activity: "Regular Work", hours: 2, minutes: 0, wage: 20)
        let fixedPayWorkTime = WorkTime(date: date, activity: "Fixed Pay Work", fixedPay: 50)

        // One Payout including both workTimes
        let payout = Payout(id: UUID(), date: date, workTimes: [regularWorkTime, fixedPayWorkTime])

        // Initialize FileUserData with these
        let userData = FileUserData(
            workTimes: [regularWorkTime, fixedPayWorkTime],
            payouts: [payout],
            userDefaults: .testing()
        )

        // totalWorkingDuration only includes the regular one (2h)
        #expect(userData.totalWorkingDuration.hour == 2)
        #expect(userData.totalWorkingDuration.minute == 0)

        // totalWorkTimePayIncludingDebts includes both: (2 * 20) + 50 = 90
        #expect(userData.totalWorkTimePayIncludingDebts == 90)

        // workTimes and payouts are assigned as expected
        #expect(userData.workTimes.count == 2)
        #expect(userData.payouts.count == 1)

        #expect(userData.workTimes.contains(where: { $0.activity == "Regular Work" }) == true)
        #expect(userData.workTimes.contains(where: { $0.activity == "Fixed Pay Work" }) == true)

        #expect(userData.payouts.contains(where: { $0.id == payout.id }) == true)
    }

    @Test("Init with only zero-pay workTimes")
    func testInitWithZeroPayWorkTimes() {
        let date = Date()
        // Two workTimes with pay == 0
        let zeroPayWorkTime1 = WorkTime(date: date, activity: "Zero Pay 1", hours: 1, minutes: 0, wage: 0)
        let zeroPayWorkTime2 = WorkTime(date: date, activity: "Zero Pay 2", hours: 3, minutes: 0, wage: 0)

        let userData = FileUserData(
            workTimes: [zeroPayWorkTime1, zeroPayWorkTime2],
            payouts: [],
            userDefaults: .testing()
        )

        // totalWorkingDuration should be zero because pay is zero
        #expect(userData.totalWorkingDuration.hour == 0)
        #expect(userData.totalWorkingDuration.minute == 0)

        // totalWorkTimePayIncludingDebts should be zero
        #expect(userData.totalWorkTimePayIncludingDebts == 0)
    }

    @Test("Init with only fixed pay workTimes")
    func testInitWithOnlyFixedPayWorkTimes() {
        let date = Date()
        // WorkTimes all fixed pay
        let fixedPay1 = WorkTime(date: date, activity: "Fixed Pay 1", fixedPay: 60)
        let fixedPay2 = WorkTime(date: date, activity: "Fixed Pay 2", fixedPay: 40)

        let userData = FileUserData(workTimes: [fixedPay1, fixedPay2], payouts: [], userDefaults: .testing())

        // totalWorkingDuration should be zero (per filter in implementation)
        #expect(userData.totalWorkingDuration.hour == 0)
        #expect(userData.totalWorkingDuration.minute == 0)

        // totalWorkTimePayIncludingDebts should equal the sum of fixed pays (60 + 40 = 100)
        #expect(userData.totalWorkTimePayIncludingDebts == 100)
    }

    @Test("Init with no data")
    func testInitWithNoData() {
        // FileUserData with empty arrays
        let userData = FileUserData(workTimes: [], payouts: [], userDefaults: .testing())

        // totalWorkingDuration should be zero
        #expect(userData.totalWorkingDuration.hour == 0)
        #expect(userData.totalWorkingDuration.minute == 0)

        // totalWorkTimePayIncludingDebts should be zero
        #expect(userData.totalWorkTimePayIncludingDebts == 0)

        // workTimes and payouts empty
        #expect(userData.workTimes.count == 0)
        #expect(userData.payouts.count == 0)
    }

    @Test("FileUserData.save() correctly persists workTimes and payouts")
    func testSavePersistsWorkTimesAndPayouts() {
        let userDefaults = UserDefaults.testing()
        // Clear UserDefaults
        userDefaults.removeObject(forKey: UserDefaultsKey.workTimes)
        userDefaults.removeObject(forKey: UserDefaultsKey.payouts)
        let date = Date()
        let workTime = WorkTime(date: date, activity: "Test Activity", hours: 1, minutes: 15, wage: 30)
        let payout = Payout(id: UUID(), date: date, workTimes: [workTime])
        let userData = FileUserData(workTimes: [workTime], payouts: [payout], userDefaults: userDefaults)

        userData.save()

        // Retrieve and decode from UserDefaults
        guard
            let workTimesData = userDefaults.data(forKey: UserDefaultsKey.workTimes),
            let payoutsData = userDefaults.data(forKey: UserDefaultsKey.payouts)
        else {
            Issue.record("Data was not saved to UserDefaults")
            return
        }
        let decoder = PropertyListDecoder()
        let decodedWorkTimes = try? decoder.decode([WorkTime].self, from: workTimesData)
        let decodedPayouts = try? decoder.decode([Payout].self, from: payoutsData)

        #expect(decodedWorkTimes?.count == 1)
        #expect(decodedPayouts?.count == 1)
        #expect(decodedWorkTimes?.first == workTime)
        #expect(decodedPayouts?.first == payout)
    }

    @Test("FileUserData.init() loads data from UserDefaults correctly")
    func testInitLoadsFromUserDefaults() throws {
        let userDefaults = UserDefaults.testing()

        let date = Date()
        let workTime = WorkTime(date: date, activity: "Loaded Work", hours: 3, minutes: 30, wage: 25)
        let payout = Payout(id: UUID(), date: date, workTimes: [workTime])

        // Save encoded objects directly to UserDefaults
        let encoder = PropertyListEncoder()
        let workTimesData = try encoder.encode([workTime])
        let payoutsData = try encoder.encode([payout])
        userDefaults.set(workTimesData, forKey: UserDefaultsKey.workTimes)
        userDefaults.set(payoutsData, forKey: UserDefaultsKey.payouts)

        // Now, loading FileUserData with the empty init() should load these values
        let loadedUserData = FileUserData(userDefaults: userDefaults)
        #expect(loadedUserData.workTimes.count == 1)
        #expect(loadedUserData.payouts.count == 1)
        #expect(loadedUserData.workTimes.first == workTime)
        #expect(loadedUserData.payouts.first == payout)
    }

    @Test("FileUserData.save() and .init() round-trip data through UserDefaults")
    func testSaveAndLoadRoundTrip() {
        let userDefaults = UserDefaults.testing()

        let date = Date()
        let workTime = WorkTime(date: date, activity: "RoundTrip", hours: 4, minutes: 45, wage: 40)
        let payout = Payout(id: UUID(), date: date, workTimes: [workTime])

        // Save using FileUserData.save()
        let userDataToSave = FileUserData(workTimes: [workTime], payouts: [payout], userDefaults: userDefaults)
        userDataToSave.save()

        // Load using FileUserData.init()
        let loadedUserData = FileUserData(userDefaults: userDefaults)
        #expect(loadedUserData.workTimes.count == 1)
        #expect(loadedUserData.payouts.count == 1)
        #expect(loadedUserData.workTimes.first == workTime)
        #expect(loadedUserData.payouts.first == payout)
    }
}
