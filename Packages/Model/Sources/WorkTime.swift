//
//  WorkTime.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import Foundation

public struct WorkTime: Identifiable, Codable, Equatable, Sendable {
    public static let durationFormatter: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.unitsStyle = .abbreviated
        f.allowedUnits = [.hour, .minute]
        return f
    }()

    public var id = UUID()
    public var activity: String?
    public var date: Date
    public var duration: DateComponents
    public var wage: Double
    public var pay: Double {
        var hours = Double(duration.hour ?? 0)
        hours += Double(duration.minute ?? 0) / 60
        return hours * wage
    }
    /// Whether this item uses a fixed pay value instead of a `time * wage` value.
    /// In this case the wage is set to `1` or `-1` and the hours is the actual pay amount.
    public var isFixedPay: Bool = false

    public init(date: Date, activity: String?, duration: DateComponents, wage: Double) {
        self.date = date
        self.activity = activity
        self.duration = duration
        self.wage = wage
    }

    public init(date: Date, activity: String?, hours: Int, minutes: Int, wage: Double) {
        self.init(date: date, activity: activity, duration: DateComponents(hour: hours, minute: minutes), wage: wage)
    }

    public init(date: Date, activity: String?, fixedPay: Double) {
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

extension DateComponents {
    public func pay(using wage: Double) -> Double {
        var hours = Double(self.hour ?? 0)
        hours += Double(self.minute ?? 0) / 60
        return hours * wage
    }
}
