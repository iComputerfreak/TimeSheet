//
//  LegacyPayout.swift
//  TimeSheet
//
//  Created by Jonas Frey on 25.11.23.
//

import Foundation

struct LegacyPayout: Decodable {
    var id: UUID
    var date: Date
    var worktimes: [LegacyWorkTime]

    var duration: DateComponents {
        worktimes.map(\.duration).reduce(.zero, +)
    }
    var amount: Double {
        worktimes.map(\.pay).reduce(0, +)
    }
}
