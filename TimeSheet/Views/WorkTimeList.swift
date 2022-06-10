//
//  WorkTimeList.swift
//  TimeSheet
//
//  Created by Jonas Frey on 10.06.22.
//

import SwiftUI

struct WorkTimeList: View {
    @EnvironmentObject private var config: Config
    var worktimes: [WorkTime]
    var onDelete: ((WorkTime) -> Void)?
    
    var years: [Int] {
        worktimes
            .map(\.date.year)
            .uniqued(on: \.hashValue)
            .sorted { $0 > $1 }
    }
    
    func months(in year: Int) -> [Int] {
        worktimes
            .filter { worktime in
                worktime.date.year == year
            }
            .map(\.date.month)
            .uniqued(on: \.hashValue)
            .sorted { $0 > $1 }
    }
    
    func worktimes(in year: Int, month: Int) -> [WorkTime] {
        worktimes.filter { worktime in
            worktime.date.year == year && worktime.date.month == month
        }
        .sorted { $0.date > $1.date }
    }
    
    var body: some View {
        List {
            ForEach(years, id: \.self) { (year: Int) in
                ForEach(months(in: year), id: \.self) { (month: Int) in
                    let monthName = Calendar.current.standaloneMonthSymbols[month - 1]
                    Section {
                        ForEach(worktimes(in: year, month: month)) { (worktime: WorkTime) in
                            ListRow(worktime: worktime)
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                let worktime = worktimes(in: year, month: month)[index]
                                self.onDelete?(worktime)
                            }
                        }
                        .deleteDisabled(onDelete == nil)
                    } header: {
                        let total = worktimes(in: year, month: month)
                            .map(\.duration)
                            .reduce(DateComponents.zero, +)
                        HStack {
                            Text("\(monthName) \(year, format: .number.grouping(.never))")
                            Spacer()
                            TimeView(duration: total, wage: config.wage)
                        }
                    }
                }
            }
        }
    }
}

struct WorkTimeList_Previews: PreviewProvider {
    static var previews: some View {
        WorkTimeList(worktimes: []) { worktime in
            print("Deleting \(worktime)")
        }
    }
}
