//
//  TimeSheetEntryList.swift
//  TimeSheet
//
//  Created by Jonas Frey on 10.06.22.
//

import SwiftUI
import JFUtils

struct TimeSheetEntryList: View {
    @EnvironmentObject private var config: Config
    @EnvironmentObject private var entryStore: TimeSheetEntryStore
    
    var years: [Int] {
        entryStore.entries
            .map(\.date.year)
            .uniqued(on: \.hashValue)
            .sorted { $0 > $1 }
    }
    
    func months(in year: Int) -> [Int] {
        entryStore.entries
            .filter { entry in
                entry.date.year == year
            }
            .map(\.date.month)
            .uniqued(on: \.hashValue)
            .sorted { $0 > $1 }
    }
    
    func entries(in year: Int, month: Int) -> [any TimeSheetEntryProtocol] {
        entryStore.entries.filter { entry in
            entry.date.year == year && entry.date.month == month
        }
        .sorted { $0.date > $1.date }
    }
    
    var body: some View {
        List {
            ForEach(years, id: \.self) { (year: Int) in
                ForEach(months(in: year), id: \.self) { (month: Int) in
                    let monthName = Calendar.current.standaloneMonthSymbols[month - 1]
                    Section {
                        ForEach(entries(in: year, month: month)) { (entry: any TimeSheetEntryProtocol) in
                            ListRow(entry: entry)
                                .swipeActions {
                                    // Delete button
                                    withAnimation {
                                        Button {
                                            entries.removeAll(where: { $0.id == entry.id })
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                    .tint(.red)
                                    // Edit Button
                                    if !entry.isFixedPay {
                                        NavigationLink {
                                            AddWorkTimeView(
                                                editingItem: Binding(get: {
                                                    entryStore.entries.first(where: \.id, equals: entry.id)
                                                }, set: { newValue in
                                                    entryStore.replaceEntry(id: entry.id, with: entry)
                                                })
                                            )
                                        } label: {
                                            Label("Edit", systemImage: "pencil")
                                        }
                                    }
                                }
                        }
                        
                    } header: {
                        let totalHours = entries(in: year, month: month)
                            .filter { !$0.isFixedPay }
                            .map(\.duration)
                            .reduce(DateComponents.zero, +)
                        let totalMoney = entries(in: year, month: month)
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

struct TimeSheetEntryList_Previews: PreviewProvider {
    @State static var entries = SampleData.generateTimeSheetEntries()
    
    static var previews: some View {
        TimeSheetEntryList(entries: $entries)
        .environmentObject(Config())
    }
}
