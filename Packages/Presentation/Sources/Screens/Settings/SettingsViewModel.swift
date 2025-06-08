// Copyright © 2025 Jonas Frey. All rights reserved.

import Core
import Domain
import Foundation
import SwiftUI

public struct SettingsViewState {
    @AppStorage(UserDefaultsKey.wage)
    var wage: Double = UserDefaultsDefaultValue.wage

    @AppStorage(UserDefaultsKey.currency)
    var currency: String = UserDefaultsDefaultValue.currency

    #if DEBUG
    // TODO: Use DI
    /*@EnvironmentObject*/ var userData: UserData = .init()
    #endif

    public init() {}
}

@Observable
public class SettingsViewModel: ViewModel {
    public var state: SettingsViewState

    public init(state: SettingsViewState = .init()) {
        self.state = state
    }
}
