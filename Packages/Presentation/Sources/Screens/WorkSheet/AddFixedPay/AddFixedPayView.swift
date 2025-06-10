// Copyright © 2025 Jonas Frey. All rights reserved.

import Core
import Domain
import Model
import SwiftUI

// TODO: After refactoring everything to MVVM, go through and check what can be internal again

public struct AddFixedPayView: StatefulView {
    @Environment(\.dismiss) private var dismiss

    @State public var viewModel: ViewModel

    // swiftlint:disable:next type_contents_order
    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
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
            Button(Strings.Generic.save) {
                viewModel.saveEntry()
                dismiss()
            }
            .disabled(viewModel.isSaveButtonDisabled)
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
