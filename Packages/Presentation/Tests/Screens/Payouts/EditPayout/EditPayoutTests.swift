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
struct EditPayoutTests {
    private static let samplePayout = SampleData.screenshotPayouts.first!
    private var sut: EditPayoutView.ViewModel = .init(payout: .constant(samplePayout))

    init() {
        setupTesting()
    }

    @Test func testInit() async {
        #expect(sut.payout.id == Self.samplePayout.id)
        #expect(sut.payoutBinding.id == Self.samplePayout.id)
    }

    @Test mutating func testSave() async {
        let initialPayout = Payout(date: Date(timeIntervalSince1970: 0), worktimes: [])
        let newPayout = Payout(date: Date(timeIntervalSince1970: 100), worktimes: [])

        var payout: Payout = initialPayout
        let payoutBinding: Binding<Payout> = .init {
            payout
        } set: { newValue in
            payout = newValue
        }

        sut = .init(payout: payoutBinding)

        #expect(sut.payout.id == initialPayout.id)
        #expect(sut.payoutBinding.id == payout.id)

        sut.payout = newPayout
        sut.save()

        #expect(sut.payout.id == newPayout.id)
        #expect(sut.payoutBinding.id == newPayout.id)
    }
}
