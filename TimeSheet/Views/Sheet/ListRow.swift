//
//  ListRow.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import SwiftUI

struct ListRow: View {
    static private var durationFormatter: DateComponentsFormatter {
        let f = DateComponentsFormatter()
        f.allowedUnits = [.hour, .minute]
        f.unitsStyle = .abbreviated
        return f
    }
    
    @EnvironmentObject private var config: Config
    let entry: any TimeSheetEntryProtocol
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                if let activity = entry.title {
                    Text(activity)
                        .bold()
                }
                let date = entry.date.formatted(.dateTime.weekday().day().month(.defaultDigits))
                Text("\(date)")
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("\(entry.amount, format: .currency(code: config.currency))")
                    .bold()
                    .foregroundColor(entry.amount >= 0 ? .green : .red)
                if let hourBasedEntry = entry as? HourBasedEntry {
                    let duration = hourBasedEntry.durationString
                    Text(duration)
                }
            }
        }
    }
}

struct ListRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ListRow(entry: SampleData.generateTimeSheetEntries(count: 1).first!)
                .environment(\.locale, Locale(identifier: "de"))
                .environmentObject(Config())
        }
    }
}
