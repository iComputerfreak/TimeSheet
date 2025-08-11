// Copyright © 2025 Jonas Frey. All rights reserved.

import Core
import Foundation
import Model
import SwiftUI

public struct ListView: StatefulView {
    @State public var viewModel: ViewModel

    // swiftlint:disable:next type_contents_order
    public init(viewModel: ViewModel = .init()) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationStack {
            WorkTimeListView(
                viewModel: .init(
                    navigationTitle: Strings.List.navigationTitle,
                    worktimes: viewModel.userData.worktimes,
                    canEditWorktimes: true,
                    canDeleteWorktimes: true
                )
            )
            .toolbar { toolbarContent }
        }
        .sheet(isPresented: $viewModel.createPayoutSheetShowing) {
            CreatePayoutView()
        }
    }

    @ToolbarContentBuilder private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(Strings.List.NavigationBar.payout) {
                viewModel.didTapCreatePayout()
            }
            .accessibilityIdentifier("payout-button")
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Menu {
                NavigationLink(
                    destination: AddWorkTimeView(viewModel: .init(worktimes: viewModel.worktimesBinding))
                ) {
                    Label(Strings.CreateEntry.time, systemImage: "clock")
                        .accessibilityIdentifier("time-based")
                }
                NavigationLink(
                    destination: AddFixedPayView(viewModel: .init(worktimes: viewModel.worktimesBinding))
                ) {
                    Label(Strings.CreateEntry.fixedAmount, systemImage: "banknote")
                        .accessibilityIdentifier("fixed-amount")
                }
            } label: {
                Image(systemName: "plus")
                    .accessibilityIdentifier("add")
            }
        }
    }
}

#if DEBUG
#Preview {
    ListView(viewModel: .init())
        .previewEnvironment()
}
#endif
