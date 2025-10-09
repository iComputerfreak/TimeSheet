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
struct PayoutsTests {
    @Injected private var config: Config
    @Injected private var userData: UserData

    private let sut: PayoutsView.ViewModel = .init()

    private let payout: Payout = .init(date: Date(timeIntervalSince1970: 1_000_000), workTimes: [])

    init() {
        setupTesting()
        userData.payouts = [payout]
    }

    @Test func testPayoutBinding() async {
        let binding = sut.payoutBinding(for: payout)
        #expect(binding.wrappedValue.id == payout.id)
    }

    @Test func testEditPayout() async {
        #expect(sut.editingPayout == nil)
        sut.editPayout(payout)
        #expect(sut.editingPayout?.id == payout.id)
    }

    @Test func testDeletePayout() async {
        #expect(sut.payoutBindings.map(\.wrappedValue.id) == [payout.id])
        #expect(userData.payouts.map(\.id) == [payout.id])
        sut.deletePayout(payout)
        #expect(sut.payoutBindings.isEmpty)
        #expect(userData.payouts.isEmpty)
    }
}
