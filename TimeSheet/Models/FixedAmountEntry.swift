//
//  FixedAmountEntry.swift
//  TimeSheet
//
//  Created by Jonas Frey on 25.01.24.
//

import Foundation

struct FixedAmountEntry: TimeSheetEntryProtocol {
    let id = UUID()
    var title: String?
    var date: Date
    var entryType: TimeSheetEntryType {
        if amount >= 0 {
            return .earning
        } else {
            return .loss
        }
    }
    let isIncludedInHistory: Bool = true
    var amount: Double
    
    init(title: String? = nil, date: Date, amount: Double) {
        self.title = title
        self.date = date
        self.amount = amount
    }
}
