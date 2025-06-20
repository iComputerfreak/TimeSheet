//
//  WorkTimeList.swift
//  TimeSheet
//
//  Created by Jonas Frey on 10.06.22.
//

import Core
import SwiftUI

struct WorkTimeList: View {
    @EnvironmentObject private var config: Config
    @Binding var worktimes: [WorkTime]

    var years: [Int] {
        worktimes
            .map(\.date.year)
            .removingDuplicates()
            .sorted { $0 > $1 }
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
                                            worktimes.removeAll(where: { $0.id == worktime.id })
                                        } label: {
                                            Label(Strings.Generic.delete, systemImage: "trash")
                                        }
                                    }
                                    .tint(.red)
                                    // Edit Button
                                    if !worktime.isFixedPay {
                                        NavigationLink {
                                            AddWorkTimeView(
                                                editingItem: $worktimes
                                                    .first { $0.wrappedValue.id == worktime.id }!
                                            )
                                        } label: {
                                            Label(Strings.Generic.edit, systemImage: "pencil")
                                        }
                                    }
                                }
                        }
                    } header: {
                        let totalHours = worktimes(in: year, month: month)
                            .filter { !$0.isFixedPay }
                            .map(\.duration)
                            .reduce(DateComponents.zero, +)
                        let totalMoney = worktimes(in: year, month: month)
                            .map(\.pay)
                            .reduce(0, +)
                        HStack {
                            Text("\(monthName) \(year.formatted(.number.grouping(.never)))")
                            Spacer()
                            TimeView(duration: totalHours, amount: totalMoney)
                        }
                    }
                }
            }
        }
    }

    func months(in year: Int) -> [Int] {
        worktimes
            .filter { worktime in
                worktime.date.year == year
            }
            .map(\.date.month)
            .removingDuplicates()
            .sorted { $0 > $1 }
    }

    func worktimes(in year: Int, month: Int) -> [WorkTime] {
        worktimes.filter { worktime in
            worktime.date.year == year && worktime.date.month == month
        }
        .sorted { $0.date > $1.date }
    }
}

struct WorkTimeList_Previews: PreviewProvider {
    @State static var worktimes = SampleData.generateWorkTimes()

    static var previews: some View {
        WorkTimeList(worktimes: $worktimes)
        .environmentObject(Config())
    }
}
