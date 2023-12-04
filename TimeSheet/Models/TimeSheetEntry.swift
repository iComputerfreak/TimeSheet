//
//  TimeSheetEntry.swift
//  TimeSheet
//
//  Created by Jonas Frey on 04.12.23.
//

import Foundation

protocol TimeSheetEntry {
    var title: String { get }
    var date: Date { get }
    var isPayout: Bool { get }
    var amount: Double { get }
}
