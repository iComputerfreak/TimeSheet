//
//  PayoutsView.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import Core
import Domain
import Model
import SwiftUI

struct PayoutsView: View {
    @Injected private var config: Config
    @Injected private var userData: UserData
    @State private var editingPayout: Payout?

    var payouts: [Binding<Payout>] {
        @Bindable var userData = self.userData
        return $userData.payouts.sorted { $0.wrappedValue.date > $1.wrappedValue.date }
    }

    var body: some View {
        @Bindable var userData = self.userData
        NavigationStack {
            List {
                ForEach(payouts) { $payout in
                    NavigationLink {
                        WorkTimeList(worktimes: $payout.worktimes)
                            .navigationTitle(payout.date.formatted(.dateTime.day().month().year()))
                    } label: {
                        PayoutRow(payout: payout)
                    }
                    .swipeActions(allowsFullSwipe: true) {
                        Button {
                            userData.payouts.removeAll(where: { $0.id == payout.id })
                        } label: {
                            Label(Strings.Generic.delete, systemImage: "trash")
                        }
                        .tint(.red)
                        Button {
                            editingPayout = payout
                        } label: {
                            Label(Strings.Generic.edit, systemImage: "pencil")
                        }
                    }
                }
            }
            .navigationTitle(Strings.Payouts.navigationTitle)
        }
        .sheet(item: $editingPayout) { payout in
            let index = userData.payouts.firstIndex(where: { $0.id == payout.id })!
            EditPayoutView(payout: $userData.payouts[index])
                .environmentObject(config)
        }
    }
}

#if DEBUG
#Preview {
    PayoutsView()
        .previewEnvironment()
}
#endif
