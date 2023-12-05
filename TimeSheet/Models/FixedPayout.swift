//
//  FixedPayout.swift
//  TimeSheet
//
//  Created by Jonas Frey on 04.12.23.
//

import Foundation
import SwiftData

@Model
class FixedPayout: TimeSheetEntry {
    var id = UUID()
    var title: String?
    var date: Date
    var amount: Double
    var entryType: TimeSheetEntryType { .loss }
    
    init(title: String? = nil, date: Date, amount: Double) {
        self.title = title
        self.date = date
        self.amount = amount
    }
}
