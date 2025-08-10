// Copyright © 2025 Jonas Frey. All rights reserved.

import Core
import Domain
import Foundation
import Model
import SwiftUI

struct WorkTimeListView: StatefulView {
    // TODO: Check if VM is recreated on view updates
    @State var viewModel: ViewModel

    // swiftlint:disable:next type_contents_order
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 0) {
            List {
                ForEach(viewModel.years, id: \.self) { (year: Int) in
                    ForEach(viewModel.months(in: year), id: \.self) { (month: Int) in
                        Section {
                            ForEach(viewModel.worktimes(in: year, month: month)) { (worktime: WorkTime) in
                                ListRow(worktime: worktime)
                                    .swipeActions {
                                        deleteButton(worktime: worktime)
                                        editButton(worktime: worktime)
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
                    duration: viewModel.totalWorkingDuration,
                    amount: viewModel.totalWorktimePayIncludingDebts
                )
            }
            .bold()
            .padding(.horizontal)
            .padding(.vertical, 10)
            Divider()
        }
        .navigationTitle(viewModel.navigationTitle)
    }

    @ViewBuilder
    private func deleteButton(worktime: WorkTime) -> some View {
        if viewModel.canDeleteWorktimes {
            Button {
                withAnimation {
                    viewModel.delete(worktime)
                }
            } label: {
                Label(Strings.Generic.delete, systemImage: "trash")
            }
            .tint(.red)
        }
    }

    @ViewBuilder
    private func editButton(worktime: WorkTime) -> some View {
        if viewModel.canEditWorktimes, viewModel.isShowingEditButton(for: worktime) {
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

#if DEBUG
#Preview {
    WorkTimeListView(
        viewModel: .init(
            navigationTitle: "Work Times",
            worktimes: SampleData.screenshotWorktimes,
            canEditWorktimes: true,
            canDeleteWorktimes: true
        )
    )
    .previewEnvironment()
}
#endif
