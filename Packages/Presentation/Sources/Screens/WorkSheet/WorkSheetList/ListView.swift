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

    // TODO: Refactor out some code
    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                List {
                    ForEach(viewModel.years, id: \.self) { (year: Int) in
                        ForEach(viewModel.months(in: year), id: \.self) { (month: Int) in
                            Section {
                                ForEach(viewModel.worktimes(in: year, month: month)) { (worktime: WorkTime) in
                                    ListRow(worktime: worktime)
                                        .swipeActions {
                                            // Delete button
                                            Button {
                                                withAnimation {
                                                    viewModel.delete(worktime)
                                                }
                                            } label: {
                                                Label(Strings.Generic.delete, systemImage: "trash")
                                            }
                                            .tint(.red)
                                            // Edit Button
                                            if viewModel.isShowingEditButton(for: worktime) {
                                                NavigationLink {
                                                    AddWorkTimeView(viewModel: .init(
                                                        editingItem: viewModel.worktimeBinding(for: worktime.id)
                                                    ))
                                                } label: {
                                                    Label(Strings.Generic.edit, systemImage: "pencil")
                                                }
                                            }
                                        }
                                }
                            } header: {
                                HStack {
                                    Text(viewModel.headerString(year: year, month: month))
                                    Spacer()
                                    TimeView(
                                        duration: viewModel.totalHours(in: year, month: month),
                                        amount: viewModel.totalMoney(in: year, month: month)
                                    )
                                }
                            }
                        }
                    }
                }
                Divider()
                HStack {
                    Text(Strings.List.Footer.total)
                    Spacer()
                    TimeView(
                        duration: viewModel.userData.totalWorkingDuration,
                        amount: viewModel.userData.totalWorktimePayIncludingDebts
                    )
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
                        viewModel.didTapCreatePayout()
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
            CreatePayoutView()
        }
    }
}

#if DEBUG
#Preview {
    ListView(viewModel: .init())
        .previewEnvironment()
}
#endif
