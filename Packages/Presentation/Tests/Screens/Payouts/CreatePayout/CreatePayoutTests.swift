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
struct CreatePayoutTests {
    @Injected private var config: Config
    @Injected private var userData: UserData

    private let sut: CreatePayoutView.ViewModel = .init()

    init() {
        setupTesting()
    }

    @Test func testFullAmount() async {
        #expect(sut.fullAmount == 0)

        userData.workTimes = SampleData.screenshotWorkTimes

        #expect(sut.fullAmount == 390)
    }

    @Test func testIsCreateButtonDisabledFullPayoutMode() {
        sut.fullPayoutMode = true

        #expect(sut.isCreateButtonDisabled)

        userData.workTimes = SampleData.screenshotWorkTimes

        #expect(!sut.isCreateButtonDisabled)
    }

    @Test func testIsCreateButtonDisabledPartialPayoutMode() {
        sut.fullPayoutMode = false

        #expect(sut.isCreateButtonDisabled)

        sut.payoutAmount = 10

        #expect(!sut.isCreateButtonDisabled)
    }

    @Test func testOnAppear() {
        userData.workTimes = SampleData.screenshotWorkTimes
        sut.onAppear()
        #expect(sut.payoutAmount == 390)

        userData.workTimes = [.init(date: Date(), activity: nil, fixedPay: -1000)]
        sut.onAppear()
        #expect(sut.payoutAmount == 0, "If the total amount is negative, the payout amount should be capped to 0")
    }

    @Test func testSaveEntryFullPayout() {
        sut.fullPayoutMode = true
        userData.workTimes = SampleData.screenshotWorkTimes

        let amount = SampleData.screenshotWorkTimes.map(\.pay).reduce(0, +)
        let initialCount = userData.payouts.count

        sut.saveEntry()

        #expect(userData.payouts.count == initialCount + 1)
        #expect(userData.payouts.last?.amount == amount)
        #expect(userData.payouts.last?.workTimes == SampleData.screenshotWorkTimes)
    }

    @Test func testSaveEntryFullPayoutErrorNoEntries() {
        sut.fullPayoutMode = true
        userData.workTimes = []

        let initialCount = userData.payouts.count

        sut.saveEntry()

        #expect(sut.noEntriesShowing)
        #expect(userData.payouts.count == initialCount)
    }

    @Test func testSaveEntryPartialPayout() {
        sut.fullPayoutMode = false
        sut.payoutAmount = 100
        userData.workTimes = SampleData.screenshotWorkTimes

        let initialCount = userData.payouts.count

        sut.saveEntry()

        #expect(
            userData.payouts.count == initialCount,
            // swiftlint:disable:next line_length
            "Creating a new partial payout should not create a new payout in the respecitve tab, but instead create a new entry in the list."
        )
        #expect(userData.workTimes.last?.pay == -100)
        #expect(userData.workTimes.last?.isFixedPay == true)
    }

    @Test func testSaveEntryPartialPayoutErrorZeroAmount() {
        sut.fullPayoutMode = false
        sut.payoutAmount = 0
        userData.workTimes = SampleData.screenshotWorkTimes

        let initialCount = userData.payouts.count

        sut.saveEntry()

        #expect(sut.zeroPayoutAlertShowing)

        #expect(userData.payouts.count == initialCount)
    }
}
