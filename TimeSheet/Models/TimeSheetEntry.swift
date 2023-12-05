//
//  TimeSheetEntry.swift
//  TimeSheet
//
//  Created by Jonas Frey on 04.12.23.
//

import Foundation

/// Represents a type of time sheet entry
enum TimeSheetEntryType {
    /// A type time sheet entry that represents an earning of some kind for the user (e.g., a working time entry or a bonus)
    case earning
    /// A type of time sheet entry that represents some kind of "loss" for the user (e.g., a payout or a fee)
    case loss
}

/// Represents an entry on the time sheet
protocol TimeSheetEntry: Identifiable {
    var id: UUID { get }
    /// The title describing the entry
    var title: String? { get }
    /// The date associated with the entry
    var date: Date { get }
    /// The type of time sheet entry
    var entryType: TimeSheetEntryType { get }
    /// The total monetary amount associated with this time sheet entry
    var amount: Double { get }
}
