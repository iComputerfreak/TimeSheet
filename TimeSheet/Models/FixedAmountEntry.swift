//
//  FixedAmountEntry.swift
//  TimeSheet
//
//  Created by Jonas Frey on 04.12.23.
//

import Foundation
import SwiftData

class FixedAmountEntry: TimeSheetEntry {
    var _amount: Double {
        didSet {
            // The earning type depends on whether the amount is negative or not
            self.entryType = _amount < 0 ? .loss : .earning
        }
    }
    
    override func amount() -> Double {
        return _amount
    }
    
    init(title: String? = nil, date: Date, amount: Double) {
        super.init(title: title, date: date, entryType: amount < 0 ? .loss : .earning)
        self._amount = amount
    }
}
