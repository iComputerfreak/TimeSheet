// Copyright © 2025 Jonas Frey. All rights reserved.

import Charts
import Core
import Domain
import Model
import SwiftUI

public struct InteractiveDateChartView: StatefulView {
    @State public var viewModel: ViewModel

    // swiftlint:disable:next type_contents_order
    public init(viewModel: ViewModel = .init(data: [], graphType: .income)) {
        self.viewModel = viewModel
    }

    public var body: some View {
        Chart {
            ForEach(viewModel.displayedData, id: \.0) { date, amount in
                AreaMark(
                    x: .value(Strings.History.axisLabelDate, date),
                    y: .value(viewModel.graphType.yLabel, amount)
                )
                .interpolationMethod(.linear)
                .foregroundStyle(Gradient(colors: [.green.opacity(0.6), .green]))

                LineMark(
                    x: .value(Strings.History.axisLabelDate, date),
                    y: .value(viewModel.graphType.yLabel, amount)
                )
                .interpolationMethod(.linear)
                .foregroundStyle(.green)
            }

            if let highlightedMonth = viewModel.highlightedMonth {
                let value = viewModel.displayedData.first(where: { $0.0 == highlightedMonth })?.1 ?? 0
                BarMark(
                    x: .value(Strings.History.axisLabelDate, highlightedMonth),
                    yStart: .value(viewModel.graphType.yLabel, 0),
                    yEnd: .value(viewModel.graphType.yLabel, value),
                    width: .fixed(2)
                )
                .foregroundStyle(.primary)
                .annotation(
                    position: .top,
                    alignment: viewModel.alignment(for: highlightedMonth)
                ) {
                    AnnotationView(date: highlightedMonth, value: value, graphType: viewModel.graphType)
                }
            }
        }
        .chartXScale(range: .plotDimension(padding: 15))
        .chartXAxis {
            AxisMarks(values: .stride(by: .month)) { _ in
                AxisGridLine()
                AxisTick()
                AxisValueLabel(format: .dateTime.month(.abbreviated))
            }
        }
        .chartOverlay { proxy in
            GeometryReader { nthGeoItem in
                Rectangle()
                    .fill(.clear)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                guard let plotFrame = proxy.plotFrame else { return }
                                let xCurrent = value.location.x - nthGeoItem[plotFrame].origin.x
                                let date: Date = proxy.value(atX: xCurrent) ?? .now
                                let nearest = viewModel.nearestMonth(to: date)
                                viewModel.highlightedMonth = nearest
                            }
                            .onEnded { _ in viewModel.highlightedMonth = nil }
                    )
            }
        }
    }
}

#if DEBUG
#Preview {
    @Previewable var incomePerMonth: [(Date, Double)] = {
        let worktimesByMonth: [Date: [WorkTime]] = Dictionary(
            grouping: SampleData.generateWorkTimes(),
            by: { worktime in
                Calendar.current.date(from: DateComponents(
                    year: worktime.date.year,
                    month: worktime.date.month,
                    day: 1
                )) ?? worktime.date
            }
        )
        return Array(
            worktimesByMonth
                .mapValues { $0.map(\.pay).reduce(0, +) }
                .sorted { $0.key < $1.key }
                .prefix(12)
        )
    }()
    InteractiveDateChartView(viewModel: .init(data: incomePerMonth, graphType: .income))
        .previewEnvironment()
}
#endif
