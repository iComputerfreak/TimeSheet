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
    @State private var editingPayout: Payout?

    var payouts: [Binding<Payout>] {
        $userData.payouts.sorted { $0.wrappedValue.date > $1.wrappedValue.date }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(payouts) { $payout in
                    NavigationLink {
                        WorkTimeList(worktimes: $payout.worktimes)
                            .environmentObject(userData)
                            .environmentObject(config)
                            .navigationTitle("\(payout.date, format: .dateTime.day().month().year())")
                    } label: {
                        PayoutRow(payout: payout)
                    }
                    .swipeActions(allowsFullSwipe: true) {
                        Button {
                            userData.payouts.removeAll(where: { $0.id == payout.id })
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        .tint(.red)
                        Button {
                            editingPayout = payout
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                    }
                }
            }
            .navigationTitle("Payouts")
        }
        .sheet(item: $editingPayout) { payout in
            let index = userData.payouts.firstIndex(where: { $0.id == payout.id })!
            EditPayoutView(payout: $userData.payouts[index])
                .environmentObject(config)
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
