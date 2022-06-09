//
//  Payout.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import Foundation

struct Payout: Codable, Identifiable {
    var id = UUID()
    let date: Date
    let wage: Double
    let worktimes: [WorkTime]

    var duration: DateComponents {
        worktimes.map(\.duration).reduce(.zero, +)
    }
    var amount: Double {
        return duration.pay(using: wage)
    }
}
