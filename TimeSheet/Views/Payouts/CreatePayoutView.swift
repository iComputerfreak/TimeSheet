//
//  CreatePayoutView.swift
//  TimeSheet
//
//  Created by Jonas Frey on 06.07.22.
//

import Core
import Domain
import Model
import SwiftUI

struct CreatePayoutView: View {
    @Injected private var userData: UserData
    @Injected private var config: Config
    @Environment(\.dismiss) private var dismiss

    @State private var fullPayoutMode = true
    @State private var payoutAmount: Double = 0
    @State private var payoutDate: Date = .now
    @State private var zeroPayoutAlertShowing = false
    @State private var noEntriesShowing = false

    var fullAmount: Double {
        userData.worktimes.map(\.pay).reduce(0, +)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    DatePicker(
                        Strings.CreatePayout.date,
                        selection: $payoutDate,
                        in: Date.now.addingTimeInterval(GlobalConstants.lowestValidNegativeDateInterval) ... .now,
                        displayedComponents: .date
                    )
                    let value = userData.worktimes.map(\.pay).reduce(0, +)
                    HStack {
                        Text(Strings.CreatePayout.balance)
                        Spacer()
                        Text(value.formatted(.currency(code: config.currency)))
                            .bold()
                    }
                    Toggle(isOn: $fullPayoutMode) {
                        Text(Strings.CreatePayout.fullPayout)
                    }
                    HStack {
                        Text(Strings.CreatePayout.amount)
                        Spacer()
                        TextField(
                            Strings.CreatePayout.amountHint,
                            value: $payoutAmount,
                            format: .currency(code: config.currency)
                        )
                        .multilineTextAlignment(.trailing)
                    }
                    .disabled(fullPayoutMode)
                    .foregroundColor(fullPayoutMode ? .gray : .primary)
                } footer: {
                    if fullPayoutMode {
                        Text(Strings.CreatePayout.Messages.fullPayout)
                    } else {
                        Text(Strings.CreatePayout.Messages.specificPayout)
                    }
                }
            }
            .navigationTitle(Strings.CreatePayout.navigationTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(Strings.CreatePayout.NavigationBar.create) {
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
                            dismiss()
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
                            dismiss()
                        }
                    }
                    .accessibilityIdentifier("create-button")
                    .disabled(fullPayoutMode && userData.worktimes.isEmpty)
                    .disabled(!fullPayoutMode && payoutAmount <= 0)
                }
            }
        }
        .onAppear {
            // We should not set the initial textfield value to an illegal, negative value
            payoutAmount = max(0, fullAmount)
        }
        .alert(Strings.CreatePayout.Alerts.EmptyPayout.title, isPresented: $noEntriesShowing) {
            Button(Strings.Generic.okay) {}
        } message: {
            Text(Strings.CreatePayout.Alerts.EmptyPayout.message)
        }
    }
}

#if DEBUG
#Preview {
    CreatePayoutView()
        .previewEnvironment()
}
#endif
