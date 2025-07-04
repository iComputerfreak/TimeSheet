// Copyright © 2025 Jonas Frey. All rights reserved.

import Core
import Domain
import Model
import SwiftUI

public struct EditPayoutView: StatefulView {
    @State public var viewModel: ViewModel

    @Environment(\.dismiss) private var dismiss

    // swiftlint:disable:next type_contents_order
    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
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

#if DEBUG
#Preview {
    EditPayoutView(viewModel: .init(payout: .constant(Payout(date: .now, worktimes: []))))
        .previewEnvironment()
}
#endif
