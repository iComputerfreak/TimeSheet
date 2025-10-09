// Copyright © 2025 Jonas Frey. All rights reserved.

import Core
import Domain
import Model
import SwiftUI

extension EditPayoutView {
    @Observable
    class ViewModel: ViewModelProtocol {
        var payout: Payout

        @ObservationIgnored @Binding var payoutBinding: Payout
        @ObservationIgnored @Injected private var config: Config

        var formattedPayoutAmount: String {
            payout.amount.formatted(.currency(code: config.currency))
        }

        init(payout: Binding<Payout>) {
            self._payoutBinding = payout
            self.payout = payout.wrappedValue
        }

        func save() {
            payoutBinding = payout
        }
    }
}
