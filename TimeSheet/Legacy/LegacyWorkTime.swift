//
//  LegacyWorkTime.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import Foundation

struct LegacyWorkTime: Decodable {
    static let durationFormatter: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.unitsStyle = .abbreviated
        f.allowedUnits = [.hour, .minute]
        return f
    }()
    
    var id: UUID
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
    var isFixedPay: Bool
}
