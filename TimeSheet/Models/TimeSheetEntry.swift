//
//  TimeSheetEntry.swift
//  TimeSheet
//
//  Created by Jonas Frey on 04.12.23.
//

import Foundation
import SwiftData

/// Represents a type of time sheet entry
enum TimeSheetEntryType {
    /// A type time sheet entry that represents an earning of some kind for the user (e.g., a working time entry or a bonus)
    case earning
    /// A type of time sheet entry that represents some kind of "loss" for the user (e.g., a payout or a fee)
    case loss
}

/// Represents an entry on the time sheet
protocol TimeSheetEntryProtocol: Identifiable {
    var id: UUID { get }
    /// The title describing the entry
    var title: String? { get set }
    /// The date associated with the entry
    var date: Date { get set }
    /// The type of time sheet entry
    var entryType: TimeSheetEntryType { get }
    /// The total monetary amount associated with this time sheet entry
    func amount() -> Double
}

// !!!: We cannot use a protocol, as we would need to query all concrete subclasses with a separate @Query
// !!!: We also cannot use inheritance with a superclass, as inheritance is not yet supported by Swift Data

/// Represents an entry on the time sheet
@Model
class TimeSheetEntry: TimeSheetEntryProtocol {
    let id: UUID = UUID()
    /// The title describing the entry
    var title: String?
    /// The date associated with the entry
    var date: Date
    /// The type of time sheet entry
    var entryType: TimeSheetEntryType
    /// The total monetary amount associated with this time sheet entry
    func amount() -> Double {
        fatalError("Must be implemented in a subclass")
    }
    
    init(title: String? = nil, date: Date, entryType: TimeSheetEntryType) {
        self.title = title
        self.date = date
        self.entryType = entryType
    }
}
