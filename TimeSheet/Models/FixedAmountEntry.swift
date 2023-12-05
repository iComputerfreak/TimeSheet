//
//  FixedAmountEntry.swift
//  TimeSheet
//
//  Created by Jonas Frey on 04.12.23.
//

import Foundation
import SwiftData

@Model
class FixedAmountEntry: TimeSheetEntry {
    var id = UUID()
    var title: String?
    var date: Date
    var amount: Double
    // The earning type depends on whether the amount is negative or not
    var entryType: TimeSheetEntryType { amount < 0 ? .loss : .earning }
    
    init(title: String? = nil, date: Date, amount: Double) {
        self.title = title
        self.date = date
        self.amount = amount
    }
}
