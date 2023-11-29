//
//  Payout.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import Foundation
import SwiftData

// TODO: We changed Payout from a struct to class, check if we need to change anything elsewhere now
@Model
class Payout {
    var id = UUID()
    var date: Date
    @Relationship(deleteRule: .nullify/*, inverse: \WorkTime.payout*/)
    var worktimes: [WorkTime]

    var duration: TimeInterval {
        worktimes.map(\.duration).reduce(0, +)
    }
    var amount: Double {
        worktimes.map(\.pay).reduce(0, +)
    }
    
    init(date: Date, worktimes: [WorkTime]) {
        self.date = date
        self.worktimes = worktimes
    }
}
