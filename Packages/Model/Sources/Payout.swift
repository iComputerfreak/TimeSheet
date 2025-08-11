//
//  Payout.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import Foundation

public struct Payout: Codable, Identifiable, Equatable, Sendable {
    public var id = UUID()
    public var date: Date
    public var worktimes: [WorkTime]

    public var duration: DateComponents {
        worktimes.map(\.duration).reduce(DateComponents()) { accumulated, next in
            DateComponents(
                hour: (accumulated.hour ?? 0) + (next.hour ?? 0),
                minute: (accumulated.minute ?? 0) + (next.minute ?? 0)
            )
        }
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
