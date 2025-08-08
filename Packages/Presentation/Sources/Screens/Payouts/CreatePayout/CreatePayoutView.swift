// Copyright © 2025 Jonas Frey. All rights reserved.

import Core
import Domain
import Model
import SwiftUI

struct CreatePayoutView: StatefulView {
    @State var viewModel: ViewModel

    @Environment(\.dismiss) private var dismiss

    // swiftlint:disable:next type_contents_order
    init(viewModel: ViewModel = .init()) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    DatePicker(
                        Strings.CreatePayout.date,
                        selection: $viewModel.payoutDate,
                        in: viewModel.dateRange,
                        displayedComponents: .date
                    )
                    HStack {
                        Text(Strings.CreatePayout.balance)
                        Spacer()
                        Text(viewModel.formattedBalance)
                            .bold()
                    }
                    Toggle(isOn: $viewModel.fullPayoutMode) {
                        Text(Strings.CreatePayout.fullPayout)
                    }
                    HStack {
                        Text(Strings.CreatePayout.amount)
                        Spacer()
                        TextField(
                            Strings.CreatePayout.amountHint,
                            value: $viewModel.payoutAmount,
                            format: .currency(code: viewModel.config.currency)
                        )
                        .multilineTextAlignment(.trailing)
                    }
                    .disabled(viewModel.fullPayoutMode)
                    .foregroundColor(viewModel.fullPayoutMode ? .gray : .primary)
                } footer: {
                    if viewModel.fullPayoutMode {
                        Text(Strings.CreatePayout.Messages.fullPayout)
                    } else {
                        Text(Strings.CreatePayout.Messages.specificPayout)
                    }
                }
            }
            .navigationTitle(Strings.CreatePayout.navigationTitle)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(Strings.Generic.cancel) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(Strings.CreatePayout.NavigationBar.create) {
                        viewModel.saveEntry()
                        dismiss()
                    }
                    .accessibilityIdentifier("create-button")
                    .disabled(viewModel.isCreateButtonDisabled)
                }
            }
        }
        .onAppear(perform: viewModel.onAppear)
        .alert(Strings.CreatePayout.Alerts.EmptyPayout.title, isPresented: $viewModel.noEntriesShowing) {
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
