// Copyright © 2025 Jonas Frey. All rights reserved.

import Core
import Domain
import Foundation
import Model
import SwiftUI

extension PayoutsView {
    @Observable
    public class ViewModel: ViewModelProtocol {
        var editingPayout: Payout?

        var payoutBindings: [Binding<Payout>] {
            // TODO: Fix (use proper binding instead)
            userData.payouts.indices.map { index in
                Binding {
                    self.userData.payouts[index]
                } set: { newValue in
                    self.userData.payouts[index] = newValue
                }
            }
        }

        var payoutDateFormat: Date.FormatStyle {
            .dateTime.day().month().year()
        }

        @ObservationIgnored
        @Injected var userData: UserData

        public init() {}

        func payoutBinding(for payout: Payout) -> Binding<Payout> {
            let index = userData.payouts.firstIndex(where: { $0.id == payout.id })!
            return payoutBindings[index]
        }

        func editPayout(_ payout: Payout) {
            self.editingPayout = payout
        }

        func deletePayout(_ payout: Payout) {
            userData.payouts.removeAll(where: { $0.id == payout.id })
        }
    }
}
