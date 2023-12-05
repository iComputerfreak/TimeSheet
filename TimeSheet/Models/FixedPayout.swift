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
    var _amount: Double
    
    override func amount() -> Double {
        return _amount
    }
    
    init(title: String? = nil, date: Date, amount: Double) {
        super.init(title: title, date: date, entryType: .loss)
        self._amount = amount
    }
}
