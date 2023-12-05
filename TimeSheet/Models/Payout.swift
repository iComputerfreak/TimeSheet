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
    @Relationship(deleteRule: .nullify, inverse: \WorkTimeEntry.payout)
    var worktimes: [WorkTimeEntry]

    var duration: TimeInterval {
        worktimes.map(\.duration).reduce(0, +)
    }
    
    override func amount() -> Double {
        worktimes
            .map { $0.amount() }
            .reduce(0, +)
    }
    
    init(title: String? = nil, date: Date, worktimes: [WorkTimeEntry]) {
        // Payouts are losses, because they subtract from the total time sheet amount
        super.init(title: title, date: date, entryType: .loss)
        self.worktimes = worktimes
    }
    
    // TODO: Really required?
    required init(backingData: any BackingData<TimeSheetEntry>) {
        super.init(backingData: backingData)
    }
}
