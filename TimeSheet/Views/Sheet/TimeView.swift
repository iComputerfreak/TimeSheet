//
//  TimeView.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import Core
import Domain
import Model
import SwiftUI

struct TimeView: View {
    @Injected private var config: Config
    let duration: DateComponents
    let amount: Double

    // swiftlint:disable:next type_contents_order
    init(duration: DateComponents, amount: Double) {
        self.duration = duration
        self.amount = amount
    }

    @available(*, unavailable)
    // swiftlint:disable:next type_contents_order
    init(duration: DateComponents, wage: Double) {
        self.duration = duration
        self.amount = duration.pay(using: wage)
    }

    var body: some View {
        let timeString = WorkTime.durationFormatter.string(from: duration) ?? ""
        let moneyString = amount.formatted(.currency(code: config.currency))
        Text("\(timeString) (\(moneyString))")
    }
}

struct TimeView_Previews: PreviewProvider {
    static var previews: some View {
        TimeView(duration: .init(hour: 1, minute: 30), amount: 12 * 1.5)
    }
}
