//
//  LoggerExtension.swift
//  TimeSheet
//
//  Created by Jonas Frey on 25.01.24.
//

import OSLog

extension Logger {
    init(category: String) {
        self.init(subsystem: "de.JonasFrey.TimeSheet", category: category)
    }
}
