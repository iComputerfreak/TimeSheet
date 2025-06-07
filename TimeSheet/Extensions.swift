//
//  Extensions.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import Foundation

extension DateComponents {
    static let zero = DateComponents() + DateComponents()

    static func +(lhs: DateComponents, rhs: DateComponents) -> DateComponents {
        DateComponents(
            calendar: lhs.calendar,
            timeZone: lhs.timeZone,
            era: (lhs.era ?? 0) + (rhs.era ?? 0),
            year: (lhs.year ?? 0) + (rhs.year ?? 0),
            month: (lhs.month ?? 0) + (rhs.month ?? 0),
            day: (lhs.day ?? 0) + (rhs.day ?? 0),
            hour: (lhs.hour ?? 0) + (rhs.hour ?? 0),
            minute: (lhs.minute ?? 0) + (rhs.minute ?? 0),
            second: (lhs.second ?? 0) + (rhs.second ?? 0),
            nanosecond: (lhs.nanosecond ?? 0) + (rhs.nanosecond ?? 0),
            weekday: (lhs.weekday ?? 0) + (rhs.weekday ?? 0),
            weekdayOrdinal: (lhs.weekdayOrdinal ?? 0) + (rhs.weekdayOrdinal ?? 0),
            quarter: (lhs.quarter ?? 0) + (rhs.quarter ?? 0),
            weekOfMonth: (lhs.weekOfMonth ?? 0) + (rhs.weekOfMonth ?? 0),
            weekOfYear: (lhs.weekOfYear ?? 0) + (rhs.weekOfYear ?? 0),
            yearForWeekOfYear: (lhs.yearForWeekOfYear ?? 0) + (rhs.yearForWeekOfYear ?? 0)
        )
    }
}

extension Date {
    var day: Int {
        Calendar.current.component(.day, from: self)
    }
    var month: Int {
        Calendar.current.component(.month, from: self)
    }
    var year: Int {
        Calendar.current.component(.year, from: self)
    }
}
