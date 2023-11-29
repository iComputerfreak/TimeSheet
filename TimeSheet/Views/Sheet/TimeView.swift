//
//  TimeView.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import SwiftUI

struct TimeView: View {
    @EnvironmentObject private var config: Config
    let duration: TimeInterval
    let amount: Double
    
    init(duration: TimeInterval, amount: Double) {
        self.duration = duration
        self.amount = amount
    }
    
    var body: some View {
        let timeString = WorkTime.durationFormatter.string(from: duration) ?? ""
        let moneyString = amount.formatted(.currency(code: config.currency))
        Text("\(timeString) (\(moneyString))")
    }
}

struct TimeView_Previews: PreviewProvider {
    static var previews: some View {
        TimeView(duration: .hour + 30 * .minute, amount: 12 * 1.5)
    }
}
