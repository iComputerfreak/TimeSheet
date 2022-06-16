//
//  PayoutsView.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import SwiftUI

struct PayoutsView: View {
    @EnvironmentObject private var config: Config
    @EnvironmentObject private var userData: UserData
    @State private var payoutConfirmationShowing = false
    @State private var noEntriesShowing = false
    
    var payouts: [Payout] {
        userData.payouts.sorted { $0.date > $1.date }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(payouts) { payout in
                    NavigationLink {
                        WorkTimeList(worktimes: payout.worktimes)
                            .environmentObject(userData)
                            .environmentObject(config)
                            .navigationTitle("\(payout.date, format: .dateTime.day().month().year())")
                    } label: {
                        PayoutRow(payout: payout)
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let payout = payouts[index]
                        userData.payouts.removeAll(where: { $0.id == payout.id })
                    }
                }
            }
            .navigationTitle("Payouts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create", role: .destructive) {
                        if userData.worktimes.isEmpty {
                            self.noEntriesShowing = true
                            return
                        }
                        self.payoutConfirmationShowing = true
                    }
                }
            }
        }
        .alert("Payout", isPresented: $payoutConfirmationShowing) {
            Button("Cancel", role: .cancel) {}
            Button("Payout", role: .destructive) {
                let payout = Payout(
                    date: .now,
                    worktimes: userData.worktimes
                )
                withAnimation {
                    self.userData.payouts.append(payout)
                }
                self.userData.worktimes = []
            }
        } message: {
            Text("This will remove all entries in the list and archive them in the payouts tab. The generated payout cannot be edited.")
        }
        .alert("No Entries", isPresented: $noEntriesShowing) {
            Button("Ok") {}
        } message: {
            Text("There are no entries in the list. You cannot create an empty payout.")
        }

    }
}

struct PayoutsView_Previews: PreviewProvider {
    static var previews: some View {
        PayoutsView()
            .environmentObject(SampleData.userData)
            .environmentObject(Config())
    }
}
