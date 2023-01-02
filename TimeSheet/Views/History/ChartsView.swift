//
//  ChartsView.swift
//  TimeSheet
//
//  Created by Jonas Frey on 10.06.22.
//

import SwiftUI
import Charts

enum GraphType {
    case income
    case time
    
    var yLabel: String {
        switch self {
        case .income:
            return "Income"
        case .time:
            return "Time"
        }
    }
}

extension DateComponentsFormatter {
    convenience init(allowedUnits: NSCalendar.Unit?, unitsStyle: DateComponentsFormatter.UnitsStyle?) {
        self.init()
        if let allowedUnits {
            self.allowedUnits = allowedUnits
        }
        if let unitsStyle {
            self.unitsStyle = unitsStyle
        }
    }
}

struct ChartsView: View {
    static let historyDurationFormatter = DateComponentsFormatter(allowedUnits: [.hour, .minute], unitsStyle: .short)
    
    @EnvironmentObject private var config: Config
    @State private var graphType: GraphType = .income
    let worktimes: [WorkTime]
    
    var worktimesByMonth: [Date: [WorkTime]] {
        Dictionary(
            grouping: worktimes,
            by: { worktime in
                Calendar.current.date(from: .init(
                    year: worktime.date.year,
                    month: worktime.date.month,
                    day: 1
                )) ?? worktime.date
            }
        )
    }
    
    var incomePerMonth: [(Date, Double)] {
        worktimesByMonth
            // Do not include payouts (negative values)
            .mapValues { $0.map(\.pay).filter({ $0 > 0 }).reduce(0, +) }
            .sorted { $0.key < $1.key }
    }
    
    var hoursPerMonth: [(Date, Double)] {
        worktimesByMonth
            .mapValues { worktimes in
                worktimes
                    // Don't include fixed pay in the hours
                    .filter { !$0.isFixedPay }
                    .map(\.duration)
                    .map { duration in
                        Double(duration.hour ?? 0) + Double(duration.minute ?? 0) / 60
                    }
                    .reduce(0, +)
            }
            .sorted { $0.key < $1.key }
    }
    
    var data: [(Date, Double)] {
        switch graphType {
        case .income:
            return incomePerMonth
        case .time:
            return hoursPerMonth
        }
    }
        
    var body: some View {
        NavigationStack {
            Group {
                if worktimes.isEmpty {
                    Text("No data to display")
                } else {
                    chartsContent
                }
            }
            .navigationTitle("History")
        }
    }
    
    var chartsContent: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Picker("Graph Content", selection: $graphType) {
                    Text("Income")
                        .tag(GraphType.income)
                    Text("Time")
                        .tag(GraphType.time)
                }
                .pickerStyle(.segmented)
                InteractiveDateChart(data: data, graphType: graphType)
                    .frame(height: 200)
                    .animation(.default, value: graphType)
                    .padding(.bottom, 8)
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(data.reversed(), id: \.0) { date, income in
                        HStack {
                            Text("\(date, format: .dateTime.month(.wide).year())")
                            Spacer()
                            switch graphType {
                            case .income:
                                Text("\(income, format: .currency(code: config.currency))")
                            case .time:
                                let components = DateComponents(hour: Int(income), minute: Int(income * 60) % 60)
                                Text("\(Self.historyDurationFormatter.string(from: components) ?? "")")
                            }
                        }
                        .foregroundColor(.gray)
                    }
                }
                Spacer()
            }
            .padding()
        }
    }
}

struct ChartsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChartsView(worktimes: SampleData.userData.worktimes)
                .environmentObject(SampleData.userData)
                .environmentObject(Config())
        }
    }
}
