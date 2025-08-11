//
//  Extensions.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import Foundation

public extension Date {
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

public extension Date {
    static func fixed(year: Int, month: Int, day: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        return Calendar.current.date(from: components) ?? Date()
    }
}
