// Copyright © 2025 Jonas Frey. All rights reserved.

import Core
import Domain
import Foundation
import SwiftUI

@Observable
public class SettingsViewState {
    var wage: Double {
        didSet {
            AppStorage(UserDefaultsKey.wage).wrappedValue = wage
        }
    }

    var currency: String = UserDefaultsDefaultValue.currency {
        didSet {
            AppStorage(UserDefaultsKey.currency).wrappedValue = currency
        }
    }

    #if DEBUG
    // TODO: Use DI
    /*@EnvironmentObject*/ var userData: UserData = .init()
    #endif

    public init() {
        @AppStorage(UserDefaultsKey.wage)
        var storedWage: Double = UserDefaultsDefaultValue.wage
        self.wage = storedWage

        @AppStorage(UserDefaultsKey.currency)
        var storedCurrency: String = UserDefaultsDefaultValue.currency
        self.currency = storedCurrency
    }
}

public class SettingsViewModel: ViewModel {
    public var state: SettingsViewState

    public init(state: SettingsViewState = .init()) {
        self.state = state
    }
}
