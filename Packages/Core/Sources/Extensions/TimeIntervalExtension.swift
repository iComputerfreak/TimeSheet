// Copyright © 2025 Jonas Frey. All rights reserved.

import Foundation

public extension TimeInterval {
    static let year: TimeInterval = 365 * .day
    static let day: TimeInterval = 24 * .hour
    static let hour: TimeInterval = 60 * .minute
    static let minute: TimeInterval = 60
}
