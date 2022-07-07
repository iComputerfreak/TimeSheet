//
//  WorkTime.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import Foundation

struct WorkTime: Identifiable, Codable, Equatable {
    static let durationFormatter: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.unitsStyle = .abbreviated
        f.allowedUnits = [.hour, .minute]
        return f
    }()
    
    var id = UUID()
    var activity: String?
    var date: Date
    var duration: DateComponents
    var wage: Double
    var pay: Double {
        var hours = Double(duration.hour ?? 0)
        hours += Double(duration.minute ?? 0) / 60
        return hours * wage
    }
    /// Whether this item uses a fixed pay value instead of a `time * wage` value.
    /// In this case the wage is set to `1` or `-1` and the hours is the actual pay amount.
    var isFixedPay: Bool = false
    
    init(date: Date, activity: String?, duration: DateComponents, wage: Double) {
        self.date = date
        self.activity = activity
        self.duration = duration
        self.wage = wage
    }
    
    init(date: Date, activity: String?, hours: Double, wage: Double) {
        let h = Int(hours)
        let m = Int(hours * 60) % 60
        self.init(date: date, activity: activity, duration: DateComponents(hour: h, minute: m), wage: wage)
    }
    
    init(date: Date, activity: String?, fixedPay: Double) {
        self.init(date: date, activity: activity, hours: abs(fixedPay), wage: fixedPay < 0 ? -1 : 1)
        self.isFixedPay = true
    }
}

extension DateComponents {
    func pay(using wage: Double) -> Double {
        var hours: Double = Double(self.hour ?? 0)
        hours += Double(self.minute ?? 0) / 60
        return hours * wage
    }
}
