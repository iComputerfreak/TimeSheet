// Copyright © 2025 Jonas Frey. All rights reserved.

import Core
import Domain
import Model
import SwiftUI

struct EditPayoutView: StatefulView {
    @State var viewModel: ViewModel

    @Environment(\.dismiss) private var dismiss

    // swiftlint:disable:next type_contents_order
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            Form {
                DatePicker(Strings.CreatePayout.date, selection: $viewModel.payout.date, displayedComponents: .date)
                    .navigationTitle(Strings.CreatePayout.editNavigationTitle)
                HStack {
                    Text(Strings.CreatePayout.amountHint)
                    Spacer()
                    Text(viewModel.formattedPayoutAmount)
                        .foregroundColor(.gray)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.save()
                        dismiss()
                    } label: {
                        Label(Strings.Generic.done, systemImage: "checkmark")
                            .tint(.accentColor)
                    }
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    EditPayoutView(viewModel: .init(payout: .constant(Payout(date: .now, worktimes: []))))
        .previewEnvironment()
}
#endif
