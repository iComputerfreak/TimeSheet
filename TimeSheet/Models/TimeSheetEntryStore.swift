//
//  TimeSheetEntryStore.swift
//  TimeSheet
//
//  Created by Jonas Frey on 25.01.24.
//

import Foundation
import JFUtils
import SwiftUI
import OSLog

class TimeSheetEntryStore: ObservableObject, Codable, Savable {
    static let logger: Logger = .init(category: "TimeSheetEntryStore")
    static let dataPath: URL = Utils.documentsDirectoryURL().appending(component: "timeSheetEntryStore.json")
    
    @Published private var hourBasedEntries: [HourBasedEntry]
    @Published private var fixedAmountEntries: [FixedAmountEntry]
    @Published private var partialPayoutEntries: [PartialPayoutEntry]
    
    var entries: [any TimeSheetEntryProtocol] {
        hourBasedEntries + fixedAmountEntries + partialPayoutEntries
    }
    
    required init() {
        self.hourBasedEntries = []
        self.fixedAmountEntries = []
        self.partialPayoutEntries = []
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.hourBasedEntries = try container.decode([HourBasedEntry].self, forKey: .hourBasedEntries)
        self.fixedAmountEntries = try container.decode([FixedAmountEntry].self, forKey: .fixedAmountEntries)
        self.partialPayoutEntries = try container.decode([PartialPayoutEntry].self, forKey: .partialPayoutEntries)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.hourBasedEntries, forKey: .hourBasedEntries)
        try container.encode(self.fixedAmountEntries, forKey: .fixedAmountEntries)
        try container.encode(self.partialPayoutEntries, forKey: .partialPayoutEntries)
    }
    
    enum CodingKeys: CodingKey {
        case hourBasedEntries
        case fixedAmountEntries
        case partialPayoutEntries
    }
    
    func removeEntry(at index: Int) {
        guard index >= 0, index < entries.count else {
            assertionFailure("Tried to remove element at index \(index) from an array with \(entries.count) elements.")
            // Fail silently, because crashing here would not be an appropriate response and throwing an errors would
            // feel over-the-top in a remove function.
            return
        }
        
        // Remove from the appropriate array
        if index < hourBasedEntries.count {
            hourBasedEntries.remove(at: index)
        } else if index < (hourBasedEntries.count + fixedAmountEntries.count) {
            fixedAmountEntries.remove(at: (index - hourBasedEntries.count))
        } else {
            partialPayoutEntries.remove(at: (index - hourBasedEntries.count - fixedAmountEntries.count))
        }
    }
}

// HourBasedEntry Extension
extension TimeSheetEntryStore {
    func addEntry(_ entry: HourBasedEntry) {
        hourBasedEntries.append(entry)
    }
    
    func removeEntry(_ entry: HourBasedEntry) {
        hourBasedEntries.removeAll(where: \.id, equals: entry.id)
    }
}

// FixedAmountEntry Extension
extension TimeSheetEntryStore {
    func addEntry(_ entry: FixedAmountEntry) {
        fixedAmountEntries.append(entry)
    }
    
    func removeEntry(_ entry: FixedAmountEntry) {
        fixedAmountEntries.removeAll(where: \.id, equals: entry.id)
    }
}

// PartialPayoutEntry Extension
extension TimeSheetEntryStore {
    func addEntry(_ entry: PartialPayoutEntry) {
        partialPayoutEntries.append(entry)
    }
    
    func removeEntry(_ entry: PartialPayoutEntry) {
        partialPayoutEntries.removeAll(where: \.id, equals: entry.id)
    }
}
