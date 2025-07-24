// Copyright © 2025 Jonas Frey. All rights reserved.

@testable import Presentation

import Model
import SwiftUI
import Testing

@MainActor
@Suite(.tags(.snapshot))
struct PayoutRowSnapshotTests {
    private static let testDate = Date(timeIntervalSince1970: 1_000_000)

    init() {
        setupTesting()
    }

    @Test(
        .serialized,
        arguments: [
            [
                WorkTime(
                    date: Date(timeIntervalSince1970: 1_000_000),
                    activity: nil,
                    fixedPay: 100.59
                ),
                WorkTime(
                    date: Date(timeIntervalSince1970: 1_000_000),
                    activity: nil,
                    duration: .init(hour: 2, minute: 30),
                    wage: 15
                ),
                WorkTime(
                    date: Date(timeIntervalSince1970: 1_000_000),
                    activity: nil,
                    hours: 1,
                    minutes: 15,
                    wage: 23
                )
            ],
            [
                WorkTime(
                    date: Date(timeIntervalSince1970: 1_000_000),
                    activity: nil,
                    fixedPay: 100.59
                )
            ],
            [
                WorkTime(
                    date: Date(timeIntervalSince1970: 1_000_000),
                    activity: nil,
                    duration: .init(hour: 2, minute: 30),
                    wage: 15
                )
            ],
            [
                WorkTime(
                    date: Date(timeIntervalSince1970: 1_000_000),
                    activity: nil,
                    hours: 1,
                    minutes: 15,
                    wage: 23
                )
            ]
        ]
    )
    func testPayoutRow(worktimes: [WorkTime]) {
        assertSnapshot(height: 400) {
            List {
                PayoutRow(payout: Payout(date: Self.testDate, worktimes: worktimes))
            }
        }
    }
}
