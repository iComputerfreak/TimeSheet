//
//  Payout.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import Foundation

public struct Payout: Codable, Identifiable, Equatable, Sendable {
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case workTimes = "worktimes"
    }

    public var id = UUID()
    public var date: Date
    public var workTimes: [WorkTime]

    public var duration: DateComponents {
        workTimes.map(\.duration).reduce(DateComponents()) { accumulated, next in
            DateComponents(
                hour: (accumulated.hour ?? 0) + (next.hour ?? 0),
                minute: (accumulated.minute ?? 0) + (next.minute ?? 0)
            )
        }
    }

    public var amount: Double {
        workTimes.map(\.pay).reduce(0, +)
    }

    public init(
        id: UUID = UUID(),
        date: Date,
        workTimes: [WorkTime]
    ) {
        self.id = id
        self.date = date
        self.workTimes = workTimes
    }
}
