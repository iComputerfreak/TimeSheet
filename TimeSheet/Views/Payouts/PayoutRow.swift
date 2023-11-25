//
//  PayoutRow.swift
//  TimeSheet
//
//  Created by Jonas Frey on 10.06.22.
//

import SwiftUI

struct PayoutRow: View {
    private static var durationFormatter: DateComponentsFormatter {
        let f = DateComponentsFormatter()
        f.allowedUnits = [.hour, .minute]
        f.unitsStyle = .short
        return f
    }
    
    @EnvironmentObject private var config: Config
    let payout: Payout
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text("\(payout.date, format: .dateTime.day().month().year())")
                    .font(.headline)
                let duration = Self.durationFormatter.string(from: payout.duration) ?? ""
                Text("\(duration)")
            }
            Spacer()
            let total = payout.amount.formatted(.currency(code: config.currency))
            Text(total)
                .font(.title2)
                .foregroundColor(payout.amount >= 0 ? .green : .red)
        }
    }
}

struct PayoutRow_Previews: PreviewProvider {
    static var previews: some View {
        PayoutRow(payout: .init(date: .now, worktimes: SampleData.generateWorkTimes(count: 10)))
        .previewLayout(.sizeThatFits)
    }
}
