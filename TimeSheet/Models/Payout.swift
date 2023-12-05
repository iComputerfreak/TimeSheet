//
//  Payout.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import Foundation
import SwiftData

@Model
class Payout: TimeSheetEntry {
    var id = UUID()
    var title: String?
    var date: Date
    @Relationship(deleteRule: .nullify, inverse: \WorkTimeEntry.payout)
    var worktimes: [WorkTimeEntry]
    // Payouts are losses, because they subtract from the total time sheet amount
    var entryType: TimeSheetEntryType { .loss }

    var duration: TimeInterval {
        worktimes.map(\.duration).reduce(0, +)
    }
    
    var amount: Double {
        worktimes.map(\.pay).reduce(0, +)
    }
    
    init(title: String? = nil, date: Date, worktimes: [WorkTimeEntry]) {
        self.date = date
        self.worktimes = worktimes
    }
}
