//
//  WorkTimeList.swift
//  TimeSheet
//
//  Created by Jonas Frey on 10.06.22.
//

import SwiftData
import SwiftUI
import JFUtils

struct WorkTimeList: View {
    @EnvironmentObject private var config: Config
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: [.init(\WorkTime.date)], animation: .default)
    private var worktimes: [WorkTime]
    
    var years: [Int] {
        worktimes
            .map(\.date.year)
            .uniqued(on: \.hashValue)
            .sorted(by: >)
    }
    
    func months(in year: Int) -> [Int] {
        worktimes
            .filter { worktime in
                worktime.date.year == year
            }
            .map(\.date.month)
            .uniqued(on: \.hashValue)
            .sorted(by: >)
    }
    
    // TODO: Should probably be done in a Query in a subview
    func worktimes(in year: Int, month: Int) -> [WorkTime] {
        worktimes.filter { worktime in
            worktime.date.year == year && worktime.date.month == month
        }
        .sorted(on: \.date, by: >)
    }
    
    var body: some View {
        List {
            ForEach(years, id: \.self) { (year: Int) in
                ForEach(months(in: year), id: \.self) { (month: Int) in
                    let monthName = Calendar.current.standaloneMonthSymbols[month - 1]
                    Section {
                        ForEach(worktimes(in: year, month: month)) { (worktime: WorkTime) in
                            ListRow(worktime: worktime)
                                .swipeActions {
                                    // Delete button
                                    withAnimation {
                                        Button {
                                            self.modelContext.delete(worktime)
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                    .tint(.red)
                                    // Edit Button
                                    if !worktime.isFixedPay {
                                        NavigationLink {
                                            AddWorkTimeView(editingItem: worktime)
                                        } label: {
                                            Label("Edit", systemImage: "pencil")
                                        }
                                    }
                                }
                        }
                    } header: {
                        let totalHours = worktimes(in: year, month: month)
                            .filter { !$0.isFixedPay }
                            .map(\.duration)
                            .reduce(0, +)
                        let totalMoney = worktimes(in: year, month: month)
                            .map(\.pay)
                            .reduce(0, +)
                        HStack {
                            Text("\(monthName) \(year, format: .number.grouping(.never))")
                            Spacer()
                            TimeView(duration: totalHours, amount: totalMoney)
                        }
                    }
                }
            }
        }
    }
}

struct WorkTimeList_Previews: PreviewProvider {
    @State static var worktimes = SampleData.generateWorkTimes()
    
    static var previews: some View {
        WorkTimeList()
            .environmentObject(Config())
    }
}
