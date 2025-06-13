// Copyright © 2025 Jonas Frey. All rights reserved.

import Foundation
import Model

public protocol UserData: AnyObject, Observable, Sendable {
    var worktimes: [WorkTime] { get set }
    var payouts: [Payout] { get set }
    var totalWorkingDuration: DateComponents { get }
    var totalWorktimePayIncludingDebts: Double { get }

    init(worktimes: [WorkTime], payouts: [Payout])
    init()

    func save()
}
