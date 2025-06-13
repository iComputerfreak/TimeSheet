//
//  UserData.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import Core
import Foundation
import Model
import SwiftUI

@Observable
public final class MockUserData: UserData, @unchecked Sendable {
    public var worktimes: [WorkTime]
    public var payouts: [Payout]

    public var totalWorkingDuration: DateComponents {
        worktimes
            .filter { !$0.isFixedPay }
            .filter { $0.pay > 0 }
            .map(\.duration)
            .reduce(.zero, +)
    }

    public var totalWorktimePayIncludingDebts: Double {
        worktimes
            .map(\.pay)
            .reduce(0, +)
    }

    public init(worktimes: [WorkTime], payouts: [Payout]) {
        self.worktimes = worktimes
        self.payouts = payouts
    }

    public init() {
        self.worktimes = []
        self.payouts = []
    }

    public func save() {}
}
