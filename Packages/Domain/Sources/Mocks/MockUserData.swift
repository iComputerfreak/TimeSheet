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
    public var workTimes: [WorkTime]
    public var payouts: [Payout]

    public var totalWorkingDuration: DateComponents {
        workTimes
            .filter { !$0.isFixedPay }
            .filter { $0.pay > 0 }
            .map(\.duration)
            .reduce(.zero, +)
    }

    public var totalWorkTimePayIncludingDebts: Double {
        workTimes
            .map(\.pay)
            .reduce(0, +)
    }

    public init(workTimes: [WorkTime], payouts: [Payout]) {
        self.workTimes = workTimes
        self.payouts = payouts
    }

    public init() {
        self.workTimes = []
        self.payouts = []
    }

    public func save() {}
}
