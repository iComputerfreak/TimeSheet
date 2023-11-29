//
//  WorkTime.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import Foundation
import SwiftData

@Model
class WorkTime {
    static let durationFormatter: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.unitsStyle = .abbreviated
        f.allowedUnits = [.hour, .minute]
        return f
    }()
    
    var id = UUID()
    var activity: String?
    var date: Date
    var duration: TimeInterval
    var wage: Double
    var pay: Double {
        (duration / .hour) * wage
    }
    /// Whether this item uses a fixed pay value instead of a `time * wage` value.
    /// In this case the wage is set to `1` or `-1` and the hours is the actual pay amount.
    var isFixedPay: Bool = false
    
    init(date: Date, activity: String?, duration: TimeInterval, wage: Double) {
        self.date = date
        self.activity = activity
        self.duration = duration
        self.wage = wage
    }
    
    convenience init(date: Date, activity: String?, hours: Int, minutes: Int, wage: Double) {
        self.init(
            date: date,
            activity: activity,
            duration: Double(hours) * .hour + Double(minutes) * .minute,
            wage: wage
        )
    }
    
    convenience init(date: Date, activity: String?, fixedPay: Double) {
        let minutes = Int(abs(fixedPay).truncatingRemainder(dividingBy: 1) * 60)
        self.init(
            date: date,
            activity: activity,
            hours: Int(abs(fixedPay)),
            minutes: minutes,
            wage: fixedPay < 0 ? -1 : 1
        )
        self.isFixedPay = true
    }
}
