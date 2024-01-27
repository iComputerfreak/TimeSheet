//
//  Utils.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import Foundation

let lowestValidNegativeDateInterval: TimeInterval = -100 * .year

enum Utils {
    static func documentsDirectoryURL() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[0]
    }
}
