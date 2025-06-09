// Copyright © 2025 Jonas Frey. All rights reserved.

import Core
import Domain
import Foundation
import SwiftUI

extension SettingsView {
    @Observable
    public class ViewModel: ViewModelProtocol {
        var wage: Double {
            get { config.wage }
            set { config.wage = newValue }
        }

        var currency: String {
            get { config.currency }
            set { config.currency = newValue }
        }

        @ObservationIgnored
        @Injected var config: Config

        #if DEBUG
        @ObservationIgnored
        @Injected var userData: UserData
        #endif

        public init() {}

        #if DEBUG
        func generateSampleData() {
            userData.worktimes = SampleData.screenshotWorktimes
            userData.payouts = SampleData.screenshotPayouts
        }
        #endif
    }
}
