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
    let worktime: WorkTime
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text("\(worktime.activity ?? "Work")")
                    .bold()
                let date = worktime.date.formatted(.dateTime.weekday().day().month(.defaultDigits))
                Text("\(date)")
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("\(worktime.pay, format: .currency(code: config.currency))")
                    .bold()
                    .foregroundColor(.green)
                let duration = Self.durationFormatter.string(from: worktime.duration) ?? ""
//                let wage = worktime.wage.formatted(.currency(code: config.currency))
                Text(duration)
            }
        }
    }
}

struct ListRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ListRow(worktime: SampleData.generateWorkTimes(count: 1).first!)
                .environment(\.locale, Locale(identifier: "de"))
                .environmentObject(Config())
        }
    }
}
