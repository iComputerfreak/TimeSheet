// Copyright © 2025 Jonas Frey. All rights reserved.

import Core
import Domain
import Model
import SwiftUI

struct ListRow: View {
    private static var durationFormatter: DateComponentsFormatter {
        let f = DateComponentsFormatter()
        f.allowedUnits = [.hour, .minute]
        f.unitsStyle = .abbreviated
        return f
    }

    @Injected private var config: Config
    private let workTime: WorkTime

    // swiftlint:disable:next type_contents_order
    init(workTime: WorkTime) {
        self.workTime = workTime
    }

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                if let activity = workTime.activity {
                    Text(activity)
                        .bold()
                }
                let date = workTime.date.formatted(.dateTime.weekday().day().month(.defaultDigits))
                Text(date)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(workTime.pay.formatted(.currency(code: config.currency)))
                    .bold()
                    .foregroundColor(workTime.pay >= 0 ? .green : .red)
                let duration = Self.durationFormatter.string(from: workTime.duration) ?? ""
                if !workTime.isFixedPay {
                    Text(duration)
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    List {
        ListRow(workTime: SampleData.generateWorkTimes(count: 1).first!)
            .previewEnvironment()
    }
}
#endif
