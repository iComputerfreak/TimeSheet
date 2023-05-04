//
//  EditPayoutView.swift
//  TimeSheet
//
//  Created by Jonas Frey on 04.05.23.
//

import SwiftUI

struct EditPayoutView: View {
    @Binding var payout: Payout
    @EnvironmentObject private var config: Config
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                DatePicker("Date", selection: $payout.date, displayedComponents: .date)
                    .navigationTitle("Edit Payout")
                HStack {
                    Text("Amount")
                    Spacer()
                    Text(payout.amount.formatted(.currency(code: config.currency)))
                        .foregroundColor(.gray)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                            .bold()
                    }
                }
            }
        }
    }
}

struct EditPayoutView_Previews: PreviewProvider {
    static var previews: some View {
        EditPayoutView(payout: .constant(Payout(date: .now, worktimes: [])))
            .environmentObject(Config())
    }
}
