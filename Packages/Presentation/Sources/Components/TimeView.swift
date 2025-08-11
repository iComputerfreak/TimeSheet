// Copyright © 2025 Jonas Frey. All rights reserved.

import Core
import Domain
import Model
import SwiftUI

public struct TimeView: View {
    let duration: DateComponents
    let amount: Double

    @Injected private var config: Config

    // swiftlint:disable:next type_contents_order
    public init(duration: DateComponents, amount: Double) {
        self.duration = duration
        self.amount = amount
    }

    public var body: some View {
        let timeString = WorkTime.durationFormatter.string(from: duration) ?? ""
        let moneyString = amount.formatted(.currency(code: config.currency))
        Text("\(timeString) (\(moneyString))")
    }
}

#if DEBUG
#Preview {
    TimeView(duration: .init(hour: 1, minute: 30), amount: 12 * 1.5)
}
#endif
