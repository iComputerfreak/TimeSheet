// Copyright © 2025 Jonas Frey. All rights reserved.

import Core
import Domain
import Model
import SwiftUI

public struct PayoutsView: StatefulView {
    @State public var viewModel: ViewModel

	// swiftlint:disable:next type_contents_order
	public init(viewModel: ViewModel = ViewModel()) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.payoutBindings) { $payout in
                    NavigationLink {
                        WorkTimeListView(
                            viewModel: .init(
                                navigationTitle: payout.date.formatted(viewModel.payoutDateFormat),
                                worktimes: payout.worktimes,
                                canEditWorktimes: false,
                                canDeleteWorktimes: false
                            )
                        )
                    } label: {
                        PayoutRow(payout: payout)
                    }
                    .swipeActions(allowsFullSwipe: true) {
                        Button {
                            viewModel.deletePayout(payout)
                        } label: {
                            Label(Strings.Generic.delete, systemImage: "trash")
                        }
                        .tint(.red)
                        Button {
                            viewModel.editPayout(payout)
                        } label: {
                            Label(Strings.Generic.edit, systemImage: "pencil")
                        }
                    }
                }
            }
            .navigationTitle(Strings.Payouts.navigationTitle)
        }
        .sheet(item: $viewModel.editingPayout) { payout in
            EditPayoutView(viewModel: .init(payout: viewModel.payoutBinding(for: payout)))
        }
    }
}

#Preview {
    PayoutsView()
        .previewEnvironment()
}
