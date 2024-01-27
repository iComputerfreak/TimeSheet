//
//  ExporterProtocol.swift
//  TimeSheet
//
//  Created by Jonas Frey on 27.01.24.
//

import Foundation

protocol ExporterProtocol {
    associatedtype Output
    
    func export(_ worktimes: [WorkTime], startDate: Date?, endDate: Date?) throws -> Output
}
