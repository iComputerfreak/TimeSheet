//
//  CreatePayoutView.swift
//  TimeSheet
//
//  Created by Jonas Frey on 06.07.22.
//

import SwiftUI

struct CreatePayoutView: View {
    @EnvironmentObject private var userData: UserData
    @EnvironmentObject private var config: Config
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
                        "Date",
                        selection: $payoutDate,
                        in: Date.now.addingTimeInterval(lowestValidNegativeDateInterval) ... .now,
                        displayedComponents: .date
                    )
                    let value = userData.worktimes.map(\.pay).reduce(0, +)
                    HStack {
                        Text("Balance")
                        Spacer()
                        Text("\(value, format: .currency(code: config.currency))")
                            .bold()
                    }
                    Toggle(isOn: $fullPayoutMode) {
                        Text("Full Payout")
                    }
                    HStack {
                        Text("Payout Amount")
                        Spacer()
                        TextField("Amount", value: $payoutAmount, format: .currency(code: config.currency))
                            .multilineTextAlignment(.trailing)
                    }
                    .disabled(fullPayoutMode)
                    .foregroundColor(fullPayoutMode ? .gray : .primary)
                } footer: {
                    if fullPayoutMode {
                        Text("When creating a full payout, all entries in the time sheet will be removed and archived in the payouts tab. The generated payout cannot be edited.")
                    } else {
                        Text("When creating a specific payout, the payout amount will be added as a separate entry in the time sheet and all other entries will remain.")
                    }
                }
            }
                .navigationTitle("Create Payout")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Create") {
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
                                let worktime = WorkTimeEntry(
                                    date: payoutDate,
                                    activity: String(localized: "Payout"),
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
        .alert("No Entries", isPresented: $noEntriesShowing) {
            Button("Ok") {}
        } message: {
            Text("There are no entries in the list. You cannot create an empty payout.")
        }
    }
}

struct CreatePayoutView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePayoutView()
            .environmentObject(SampleData.userData)
            .environmentObject(Config())
    }
}
