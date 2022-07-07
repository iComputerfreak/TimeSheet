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
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let payout = payouts[index]
                        userData.payouts.removeAll(where: { $0.id == payout.id })
                    }
                }
            }
            .navigationTitle("Payouts")
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
