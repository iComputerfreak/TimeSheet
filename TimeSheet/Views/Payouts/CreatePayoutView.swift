//
//  CreatePayoutView.swift
//  TimeSheet
//
//  Created by Jonas Frey on 06.07.22.
//

import SwiftData
import SwiftUI

struct CreatePayoutView: View {
    @EnvironmentObject private var userData: UserData
    @EnvironmentObject private var config: Config
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    
    @State private var fullPayoutMode = true
    @State private var payoutAmount: Double = 0
    @State private var payoutDate: Date = .now
    @State private var noEntriesShowing = false
    
    @Query(filter: WorkTimeEntry.notPaidOutPredicate, animation: .default)
    var worktimes: [WorkTimeEntry]
    
    var fullAmountAvailable: Double {
        worktimes.map(\.pay).reduce(0, +)
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
                                // TODO: Remove?
                                guard !worktimes.isEmpty else {
                                    self.noEntriesShowing = true
                                    return
                                }
                                // Create the payout
                                let payout = Payout(
                                    date: payoutDate,
                                    worktimes: worktimes
                                )
                                withAnimation {
                                    modelContext.insert(payout)
                                }
                                dismiss()
                            } else {
                                // Should not be possible, as the "Create" button is disabled in that condition
                                guard payoutAmount > 0 else {
                                    return
                                }
                                let fixedPayout = FixedPayout(
                                    date: payoutDate,
                                    amount: payoutAmount
                                )
                                withAnimation {
                                    modelContext.insert(fixedPayout)
                                }
                                dismiss()
                            }
                        }
                        .accessibilityIdentifier("create-button")
                        // TODO: Show an error message when worktimes is empty
                        .disabled(fullPayoutMode && worktimes.isEmpty)
                        .disabled(!fullPayoutMode && (payoutAmount <= 0 || payoutAmount > fullAmountAvailable))
                    }
                }
        }
        .onAppear {
            // We should not set the initial textfield value to an illegal, negative value
            payoutAmount = max(0, fullAmountAvailable)
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
