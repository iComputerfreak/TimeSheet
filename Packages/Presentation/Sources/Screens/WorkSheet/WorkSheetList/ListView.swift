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
                    workTimes: viewModel.userData.workTimes,
                    canEditWorkTimes: true,
                    canDeleteWorkTimes: true
                )
            )
            .toolbar { toolbarContent }
        }
        .sheet(isPresented: $viewModel.createPayoutSheetShowing) {
            CreatePayoutView()
        }
        .sheet(isPresented: $viewModel.addWorkTimeViewShowing) {
            AddWorkTimeView(viewModel: .init(workTimes: viewModel.workTimesBinding))
        }
        .sheet(isPresented: $viewModel.addFixedPayViewShowing) {
            AddFixedPayView(viewModel: .init(workTimes: viewModel.workTimesBinding))
        }
    }

    @ToolbarContentBuilder private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(Strings.List.NavigationBar.payout) {
                viewModel.createPayoutSheetShowing = true
            }
            .accessibilityIdentifier("payout-button")
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Menu {
                Button {
                    viewModel.addWorkTimeViewShowing = true
                } label: {
                    Label(Strings.CreateEntry.time, systemImage: "clock")
                        .accessibilityIdentifier("time-based")
                }
                Button {
                    viewModel.addFixedPayViewShowing = true
                } label: {
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
