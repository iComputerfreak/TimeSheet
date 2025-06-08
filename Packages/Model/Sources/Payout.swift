//
//  Payout.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import Core
import Foundation

public struct Payout: Codable, Identifiable {
    public var id = UUID()
    public var date: Date
    public var worktimes: [WorkTime]

    public var duration: DateComponents {
        worktimes.map(\.duration).reduce(.zero, +)
    }

    public var amount: Double {
        worktimes.map(\.pay).reduce(0, +)
    }

    public init(
        id: UUID = UUID(),
        date: Date,
        worktimes: [WorkTime]
    ) {
        self.id = id
        self.date = date
        self.worktimes = worktimes
    }
}
