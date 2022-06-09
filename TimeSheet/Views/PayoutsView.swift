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
    
    var body: some View {
        NavigationView {
            List(userData.payouts.sorted { $0.date > $1.date }) { payout in
                PayoutRow(payout: payout)
            }
            .navigationTitle("Payouts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Generate", role: .destructive) {
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
                    wage: config.wage,
                    worktimes: userData.worktimes
                )
                withAnimation {
                    self.userData.payouts.append(payout)
                }
                self.userData.worktimes = []
            }
        } message: {
            Text("This will remove all entries in the list and archive them in the payouts tab. The generated payout cannot be edited or removed.")
        }
    }
}

struct PayoutRow: View {
    let payout: Payout
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Payout on \(payout.date, format: .dateTime.day().month().year())")
                .font(.headline)
            let duration = WorkTime.durationFormatter.string(from: payout.duration)!
            let wage = payout.wage.formatted(.currency(code: "EUR"))
            let total = payout.amount.formatted(.currency(code: "EUR"))
            HStack(alignment: .top) {
                VStack {
                    Text("\(duration) à \(wage)")
                }
                Spacer()
                Text(total)
                    .font(.title2)
                    .foregroundColor(.green)
            }
        }
    }
}

struct PayoutsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PayoutsView()
                .environmentObject(UserData(worktimes: [], payouts: [
                    .init(date: .now, wage: 12, worktimes: [.init(date: .now, hours: 20)]),
                    .init(date: .now.addingTimeInterval(31 * .day), wage: 12, worktimes: [.init(date: .now.addingTimeInterval(31 * .day), hours: 40)]),
                    .init(date: .now.addingTimeInterval(100 * .day), wage: 12, worktimes: [.init(date: .now.addingTimeInterval(100 * .day), hours: 10)]),
                ]))
                .environmentObject(Config())
        }
    }
}
