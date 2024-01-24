//
//  HourBasedEntry.swift
//  TimeSheet
//
//  Created by Jonas Frey on 22.01.24.
//

import Foundation
import SwiftUI

struct HourBasedEntry: TimeSheetEntryProtocol {
    static let durationFormatter: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.unitsStyle = .abbreviated
        f.allowedUnits = [.hour, .minute]
        return f
    }()
    
    let id = UUID()
    var title: String?
    var date: Date
    let entryType: TimeSheetEntryType = .earning
    let isIncludedInHistory: Bool = true
    var wage: Double
    var duration: TimeInterval
    
    var amount: Double {
        return wage * (duration / .hour)
    }
    
    var durationString: String {
        if let durationString = Self.durationFormatter.string(from: DateComponents(second: Int(duration))) {
            return durationString
        } else {
            // Fallback representation
            return (duration / .hour)
                .formatted(.number.precision(.fractionLength(...1)))
        }
    }
    
    init(title: String? = nil, date: Date, wage: Double, duration: TimeInterval) {
        self.title = title
        self.date = date
        self.wage = wage
        self.duration = duration
    }
}
