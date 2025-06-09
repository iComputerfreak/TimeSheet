// Copyright © 2025 Jonas Frey. All rights reserved.

import Core
import Domain
import Foundation
import SwiftUI

extension SettingsView {
    @Observable
    public class ViewModel: ViewModelProtocol {
        var wage: Double {
            didSet {
                AppStorage(UserDefaultsKey.wage).wrappedValue = wage
            }
        }

        var currency: String {
            didSet {
                AppStorage(UserDefaultsKey.currency).wrappedValue = currency
            }
        }

        #if DEBUG
        @ObservationIgnored
        @Injected var userData: UserData
        #endif

        public init() {
            @AppStorage(UserDefaultsKey.wage)
            var storedWage: Double = UserDefaultsDefaultValue.wage
            self.wage = storedWage

            @AppStorage(UserDefaultsKey.currency)
            var storedCurrency: String = UserDefaultsDefaultValue.currency
            self.currency = storedCurrency
        }

        func generateSampleData() {
            userData.worktimes = SampleData.screenshotWorktimes
            userData.payouts = SampleData.screenshotPayouts
        }
    }
}
