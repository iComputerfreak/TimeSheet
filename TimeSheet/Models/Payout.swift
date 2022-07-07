//
//  Payout.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import Foundation

struct Payout: Codable, Identifiable {
    var id = UUID()
    var date: Date
    var worktimes: [WorkTime]

    var duration: DateComponents {
        worktimes.map(\.duration).reduce(.zero, +)
    }
    var amount: Double {
        worktimes.map(\.pay).reduce(0, +)
    }
}
