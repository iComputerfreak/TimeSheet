// Copyright © 2025 Jonas Frey. All rights reserved.

import Core
import Domain
import Model
import SwiftUI

public struct PayoutRow: View {
    private static var durationFormatter: DateComponentsFormatter {
        let f = DateComponentsFormatter()
        f.allowedUnits = [.hour, .minute]
        f.unitsStyle = .short
        return f
    }

    @Injected private var config: Config
    let payout: Payout

    // swiftlint:disable:next type_contents_order
    public init(payout: Payout) {
        self.payout = payout
    }

    public var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(payout.date.formatted(.dateTime.day().month().year()))
                    .font(.headline)
                let duration = Self.durationFormatter.string(from: payout.duration) ?? ""
                Text(duration)
            }
            Spacer()
            let total = payout.amount.formatted(.currency(code: config.currency))
            Text(total)
                .font(.title2)
                .foregroundColor(payout.amount >= 0 ? .green : .red)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    List {
        PayoutRow(payout: .init(date: .now, worktimes: SampleData.generateWorkTimes(count: 10)))
    }
    .previewEnvironment()
}
