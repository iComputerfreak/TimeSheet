//
//  TimeView.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import SwiftUI

struct TimeView: View {
    @EnvironmentObject private var config: Config
    let duration: DateComponents
    let wage: Double
    
    var body: some View {
        let timeString = WorkTime.durationFormatter.string(from: duration)!
        let moneyString = duration.pay(using: wage).formatted(.currency(code: config.currency))
        Text("\(timeString) (\(moneyString))")
    }
}

struct TimeView_Previews: PreviewProvider {
    static var previews: some View {
        TimeView(duration: .zero, wage: 12)
    }
}
