//
//  EditPayoutView.swift
//  TimeSheet
//
//  Created by Jonas Frey on 04.05.23.
//

import Core
import Domain
import Model
import SwiftUI

struct EditPayoutView: View {
    @Binding var payout: Payout
    @Injected private var config: Config
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                DatePicker(Strings.CreatePayout.date, selection: $payout.date, displayedComponents: .date)
                    .navigationTitle(Strings.CreatePayout.editNavigationTitle)
                HStack {
                    Text(Strings.CreatePayout.amountHint)
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
                        Text(Strings.Generic.done)
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
