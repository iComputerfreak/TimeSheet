// Copyright © 2025 Jonas Frey. All rights reserved.

import Core
import Domain
import Model
import SwiftUI

struct AddWorkTimeView: StatefulView {
    @State var viewModel: ViewModel

    @Environment(\.dismiss) private var dismiss

    // swiftlint:disable:next type_contents_order
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Form {
            TextField(Strings.CreateEntry.activity, text: $viewModel.activity)
            DatePicker(selection: $viewModel.date, in: viewModel.dateRange, displayedComponents: .date) {
                Text(Strings.CreateEntry.date)
            }
            Stepper(value: $viewModel.hours, in: 0...23) {
                HStack {
                    Text(Strings.CreateEntry.hours)
                    Spacer()
                    Text(viewModel.hours.formatted())
                }
            }
            Stepper(value: $viewModel.minutes, in: 0...55, step: 5) {
                HStack {
                    Text(Strings.CreateEntry.minutes)
                    Spacer()
                    Text(viewModel.minutes.formatted())
                }
            }
            WageStepper(wage: $viewModel.wage)
        }
        .navigationTitle(Strings.CreateEntry.navigationTitle)
        .toolbar {
            Button(Strings.Generic.save) {
                viewModel.saveEntry()
                dismiss()
            }
            .disabled(viewModel.isSaveButtonDisabled)
        }
        .onAppear {
            viewModel.didAppear()
        }
        .alert(Strings.CreateEntry.Alerts.HoursMissing.title, isPresented: $viewModel.zeroHoursShowing) {
            Button(Strings.Generic.okay) {}
        } message: {
            Text(Strings.CreateEntry.Alerts.HoursMissing.message)
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        AddWorkTimeView(viewModel: .init(worktimes: .constant([])))
            .previewEnvironment()
    }
}
#endif
