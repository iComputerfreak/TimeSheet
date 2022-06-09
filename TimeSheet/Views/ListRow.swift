//
//  ListRow.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import SwiftUI

struct ListRow: View {
    @EnvironmentObject private var config: Config
    let worktime: WorkTime
    
    var body: some View {
        HStack(alignment: .top) {
            Text("\(worktime.date, format: .dateTime.weekday(.wide).day().month(.defaultDigits))")
            Spacer()
            TimeView(duration: worktime.duration, wage: config.wage)
        }
    }
}

struct ListRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ListRow(worktime: .init(date: .now, hours: 5.5))
                .environment(\.locale, Locale(identifier: "de"))
                .environmentObject(Config())
        }
    }
}
