// Copyright © 2025 Jonas Frey. All rights reserved.

import Core
import Domain
import Foundation
import Model
import SwiftUI

extension CreatePayoutView {
    @Observable
    class ViewModel: ViewModelProtocol {
        var fullPayoutMode: Bool
        var payoutAmount: Double
        var payoutDate: Date
        var zeroPayoutAlertShowing: Bool
        var noEntriesShowing: Bool

        @ObservationIgnored
        @Injected private var userData: UserData
        @ObservationIgnored
        @Injected var config: Config

        var fullAmount: Double {
            userData.worktimes.map(\.pay).reduce(0, +)
        }

        var formattedBalance: String {
            let balance = userData.worktimes.map(\.pay).reduce(0, +)
            return balance.formatted(.currency(code: config.currency))
        }

        var isCreateButtonDisabled: Bool {
            switch fullPayoutMode {
            case true:
                return userData.worktimes.isEmpty

            case false:
                return payoutAmount <= 0
            }
        }

        var dateRange: ClosedRange<Date> {
            Date(timeIntervalSinceNow: GlobalConstants.lowestValidNegativeDateInterval) ... Date()
        }

        init(
            fullPayoutMode: Bool = true,
            payoutAmount: Double = 0,
            payoutDate: Date = .now,
            zeroPayoutAlertShowing: Bool = false,
            noEntriesShowing: Bool = false
        ) {
            self.fullPayoutMode = fullPayoutMode
            self.payoutAmount = payoutAmount
            self.payoutDate = payoutDate
            self.zeroPayoutAlertShowing = zeroPayoutAlertShowing
            self.noEntriesShowing = noEntriesShowing
        }

        func onAppear() {
            // We should not set the initial textfield value to an illegal, negative value
            payoutAmount = max(0, fullAmount)
        }

        func saveEntry() {
            if fullPayoutMode {
                guard !userData.worktimes.isEmpty else {
                    self.noEntriesShowing = true
                    return
                }
                // Create the payout
                let payout = Payout(
                    date: payoutDate,
                    worktimes: userData.worktimes
                )
                withAnimation {
                    self.userData.payouts.append(payout)
                }
                self.userData.worktimes = []
            } else {
                guard payoutAmount > 0 else {
                    zeroPayoutAlertShowing = true
                    return
                }
                let worktime = WorkTime(
                    date: payoutDate,
                    activity: Strings.Payouts.activityText,
                    fixedPay: -payoutAmount
                )
                userData.worktimes.append(worktime)
            }
        }
    }
}
