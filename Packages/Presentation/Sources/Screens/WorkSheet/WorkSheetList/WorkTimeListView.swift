// Copyright © 2025 Jonas Frey. All rights reserved.

import Core
import Domain
import Foundation
import Model
import SwiftUI

struct WorkTimeListView: StatefulView {
    // We explicitly don't use @State here to force a re-render of this component view whenever the parent sets a new
    // view model. This would be comparable to this view holding the properties directly.
    @Bindable var viewModel: ViewModel

    // swiftlint:disable:next type_contents_order
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        if #available(iOS 26.0, *) {
            // On iOS 26+, we show a bottom tab bar accessory, so we don't need to show the footer here.
            listContent
        } else {
            VStack(spacing: 0) {
                listContent
                Divider()
                HStack {
                    Text(Strings.List.Footer.total)
                    Spacer()
                    TimeView(
                        duration: viewModel.totalWorkingDuration,
                        amount: viewModel.totalWorkTimePayIncludingDebts
                    )
                }
                .bold()
                .padding(.horizontal)
                .padding(.vertical, 10)
                Divider()
            }
        }
    }

    private var listContent: some View {
        List {
            ForEach(viewModel.years, id: \.self) { (year: Int) in
                ForEach(viewModel.months(in: year), id: \.self) { (month: Int) in
                    Section {
                        ForEach(viewModel.workTimes(in: year, month: month)) { (workTime: WorkTime) in
                            ListRow(workTime: workTime)
                                .swipeActions {
                                    deleteButton(workTime: workTime)
                                    editButton(workTime: workTime)
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
        .navigationTitle(viewModel.navigationTitle)
        .sheet(item: $viewModel.editingWorkTime) { workTime in
            AddWorkTimeView(viewModel: .init(editingItem: viewModel.workTimeBinding(for: workTime.id)))
        }
    }

    @ViewBuilder
    private func deleteButton(workTime: WorkTime) -> some View {
        if viewModel.canDeleteWorkTimes {
            Button {
                withAnimation {
                    viewModel.delete(workTime)
                }
            } label: {
                Label(Strings.Generic.delete, systemImage: "trash")
            }
            .tint(.red)
        }
    }

    @ViewBuilder
    private func editButton(workTime: WorkTime) -> some View {
        if viewModel.canEditWorkTimes, viewModel.isShowingEditButton(for: workTime) {
            Button {
                viewModel.editWorkTime(workTime: workTime)
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
            workTimes: SampleData.screenshotWorkTimes,
            canEditWorkTimes: true,
            canDeleteWorkTimes: true
        )
    )
    .previewEnvironment()
}
#endif
