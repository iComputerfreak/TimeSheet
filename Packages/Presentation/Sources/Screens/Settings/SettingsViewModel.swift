// Copyright © 2025 Jonas Frey. All rights reserved.

import Core
import Domain
import Foundation
import SwiftUI

extension SettingsView {
    @Observable
    public class ViewModel: ViewModelProtocol {
        let availableCurrencyCodes: [String] = {
            var codes = Locale.commonISOCurrencyCodes
            // We show the "common" codes and also the user's current default currency code
            if
                let currentCurrency = Locale.current.currency?.identifier,
                !codes.contains(currentCurrency)
            {
                codes.append(currentCurrency)
            }
            return codes
        }()

        var currency: String {
            didSet { config.currency = currency }
        }

        var wage: Double {
            didSet { config.wage = wage }
        }

        #if DEBUG
        var shouldShowGenerateButton: Bool {
            guard userData.worktimes.isEmpty else { return false }
            return !UserDefaults.standard.bool(forKey: UserDefaultsKey.shouldHideGenerateSampleDataButton)
        }
        #endif

        var config: Config { DependencyContext.live.resolve() }

        #if DEBUG
        var userData: UserData { DependencyContext.live.resolve() }
        #endif

        public init() {
            @Injected var config: Config
            self.currency = config.currency
            self.wage = config.wage
        }

        #if DEBUG
        func generateSampleData() {
            userData.worktimes = SampleData.screenshotWorktimes
            userData.payouts = SampleData.screenshotPayouts
        }
        #endif
    }
}
