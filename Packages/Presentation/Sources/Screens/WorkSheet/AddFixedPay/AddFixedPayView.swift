// Copyright © 2025 Jonas Frey. All rights reserved.

import Core
import Domain
import Model
import SwiftUI

struct AddFixedPayView: StatefulView {
    @Environment(\.dismiss) private var dismiss

    @State var viewModel: ViewModel

    // swiftlint:disable:next type_contents_order
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField(Strings.CreateEntry.activity, text: $viewModel.activity)
                DatePicker(selection: $viewModel.date, in: viewModel.dateRange, displayedComponents: .date) {
                    Text(Strings.CreateEntry.date)
                }
                HStack {
                    Text(Strings.CreateEntry.amount)
                    Spacer(minLength: 50)
                    TextField(
                        Strings.CreateEntry.amount,
                        value: $viewModel.payAmount,
                        format: .number.precision(.fractionLength(0...2))
                    )
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                    .toolbar {
                        ToolbarItem(placement: .keyboard) {
                            HStack {
                                Button(action: viewModel.invertPayAmount) {
                                    Text(Strings.CreateEntry.Keyboard.plusMinus)
                                        .padding(.horizontal, 4)
                                        .padding(.bottom, 2)
                                        .background {
                                            RoundedRectangle(cornerRadius: 3)
                                                .fill(Colors.secondaryAccent)
                                        }
                                }
                                Spacer()
                            }
                        }
                    }
                }
            }
            .navigationTitle(Strings.CreateEntry.navigationTitle)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(role: .legacyConfirm) {
                        viewModel.saveEntry()
                        dismiss()
                    } label: {
                        Label(Strings.Generic.save, systemImage: "checkmark")
                    }
                    .disabled(viewModel.isSaveButtonDisabled)
                }

                ToolbarItem(placement: .topBarLeading) {
                    Button(role: .legacyClose) {
                        dismiss()
                    } label: {
                        Label(Strings.Generic.cancel, systemImage: "xmark")
                    }
                }
            }
        }
        .alert(Strings.CreateEntry.Alerts.AmountMissing.title, isPresented: $viewModel.zeroHoursShowing) {
            Button(Strings.Generic.okay) {}
        } message: {
            Text(Strings.CreateEntry.Alerts.AmountMissing.message)
        }
    }
}

#if DEBUG
#Preview {
    AddFixedPayView(viewModel: .init(worktimes: .constant(SampleData.generateWorkTimes())))
        .previewEnvironment()
}
#endif
