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
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text("\(worktime.date, format: .dateTime.weekday(.wide).day().month(.defaultDigits))")
                    .bold()
                Text("\(Self.durationFormatter.string(from: worktime.duration) ?? "")")
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("\(worktime.pay, format: .currency(code: config.currency))")
                    .bold()
                    .foregroundColor(.green)
                Text("at \(worktime.wage, format: .currency(code: config.currency))/h")
                    .italic()
            }
        }
    }
}

struct ListRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ListRow(worktime: .init(date: .now, hours: 5.5, wage: 12))
                .environment(\.locale, Locale(identifier: "de"))
                .environmentObject(Config())
        }
    }
}
