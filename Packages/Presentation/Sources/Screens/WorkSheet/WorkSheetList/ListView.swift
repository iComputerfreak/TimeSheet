// Copyright © 2025 Jonas Frey. All rights reserved.

import Core
import Foundation
import SwiftUI

public struct ListView: StatefulView {
    @State public var viewModel: ViewModel

    // swiftlint:disable:next type_contents_order
    public init(viewModel: ViewModel = .init()) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
//                WorkTimeList(worktimes: $viewModel.worktimes)
                Divider()
                HStack {
                    Text(Strings.List.Footer.total)
                    Spacer()
//                    TimeView(
//                        duration: viewModel.userData.totalWorkingDuration,
//                        amount: viewModel.userData.totalWorktimePayIncludingDebts
//                    )
                }
                .bold()
                .padding(.horizontal)
                .padding(.vertical, 10)
                Divider()
            }
            .navigationTitle(Strings.List.navigationTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(Strings.List.NavigationBar.payout) {
                        viewModel.createPayoutSheetShowing = true
                    }
                    .accessibilityIdentifier("payout-button")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        NavigationLink(
                            destination: AddWorkTimeView(viewModel: .init(worktimes: $viewModel.worktimes))
                        ) {
                            Label(Strings.CreateEntry.time, systemImage: "clock")
                                .accessibilityIdentifier("time-based")
                        }
                        NavigationLink(
                            destination: AddFixedPayView(viewModel: .init(worktimes: $viewModel.worktimes))
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
        .sheet(isPresented: $viewModel.createPayoutSheetShowing) {
//            CreatePayoutView()
        }
    }
}

#if DEBUG
#Preview {
    ListView(viewModel: .init())
        .previewEnvironment()
}
#endif
