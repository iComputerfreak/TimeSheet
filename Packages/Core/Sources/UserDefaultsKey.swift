// Copyright © 2025 Jonas Frey. All rights reserved.

import Foundation

public enum UserDefaultsKey {
    public static let currency: String = "currency"
    public static let wage: String = "wage"
    public static let worktimes: String = "worktimes"
    public static let payouts: String = "payouts"
    public static let shouldHideGenerateSampleDataButton: String = "shouldHideGenerateSampleDataButton"
}

public enum UserDefaultsDefaultValue {
    public static let currency: String = "EUR"
    public static let wage: Double = 15.0
}
