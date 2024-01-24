//
//  PartialPayoutEntry.swift
//  TimeSheet
//
//  Created by Jonas Frey on 25.01.24.
//

import Foundation

struct PartialPayoutEntry: TimeSheetEntryProtocol {
    let id = UUID()
    var title: String?
    var date: Date
    /// A payout is a loss in regard to the time sheet, as we subtract the amount from the total
    let entryType: TimeSheetEntryType = .loss
    /// Payouts are not included as losses in the history
    let isIncludedInHistory: Bool = false
    var amount: Double
    
    init(title: String? = nil, date: Date, amount: Double) {
        self.title = title
        self.date = date
        self.amount = amount
    }
}
