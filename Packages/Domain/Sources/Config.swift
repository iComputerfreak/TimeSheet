//
//  Config.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import Core
import Foundation
import SwiftUI

@Observable
public class Config {
    public var wage: Double {
        didSet {
            UserDefaults.standard.set(wage, forKey: UserDefaultsKey.wage)
        }
    }

    public var currency: String {
        didSet {
            UserDefaults.standard.set(currency, forKey: UserDefaultsKey.currency)
        }
    }

    public init() {
        let loadedWage = UserDefaults.standard.double(forKey: UserDefaultsKey.wage)
        self.wage = loadedWage > 0 ? loadedWage : UserDefaultsDefaultValue.wage

        let loadedCurrency = UserDefaults.standard.string(forKey: UserDefaultsKey.currency)
        self.currency = loadedCurrency ?? Locale.current.currency?.identifier ?? "EUR"
    }
}
