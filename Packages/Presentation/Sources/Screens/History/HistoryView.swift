// Copyright © 2025 Jonas Frey. All rights reserved.

import Core
import Domain
import Model
import SwiftUI

public struct HistoryView: View {
    @State private var viewModel: ViewModel

    // swiftlint:disable:next type_contents_order
    public init(viewModel: ViewModel = .init()) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationStack {
            Group {
                if viewModel.worktimes.isEmpty {
                    Text(Strings.History.noDataToShow)
                } else {
                    chartsContent
                }
            }
            .navigationTitle(Strings.History.navigationTitle)
        }
    }

    var chartsContent: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Picker(Strings.History.graphContent, selection: $viewModel.graphType) {
                    Text(Strings.History.GraphType.income)
                        .tag(GraphType.income)
                    Text(Strings.History.GraphType.time)
                        .tag(GraphType.time)
                }
                .pickerStyle(.segmented)

                InteractiveDateChartView(viewModel: .init(data: viewModel.data, graphType: viewModel.graphType))
                    .frame(height: 200)
                    .animation(.default, value: viewModel.graphType)
                    .padding(.bottom, 8)

                monthList

                Spacer()
            }
            .padding()
        }
    }

    private var monthList: some View {
        VStack(alignment: .leading, spacing: 5) {
            ForEach(viewModel.data.reversed(), id: \.0) { date, income in
                HStack {
                    Text("\(date, format: .dateTime.month(.wide).year())")
                    Spacer()
                    switch viewModel.graphType {
                    case .income:
                        Text(income.formatted(.currency(code: viewModel.currency)))
                    case .time:
                        let components = DateComponents(hour: Int(income), minute: Int(income * 60) % 60)
                        Text(ViewModel.historyDurationFormatter.string(from: components) ?? "")
                    }
                }
                .foregroundColor(.gray)
            }
        }
    }
}

#if DEBUG
#Preview {
    HistoryView()
        .previewEnvironment()
}
#endif
