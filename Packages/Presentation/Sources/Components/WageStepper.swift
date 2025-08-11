// Copyright © 2025 Jonas Frey. All rights reserved.

import Core
import SwiftUI

struct WageStepper: View {
    @AppStorage(UserDefaultsKey.currency)
    private var currencyCode: String = UserDefaultsDefaultValue.currency

    @Binding private var wage: Double

    // swiftlint:disable:next type_contents_order
    init(wage: Binding<Double>) {
        self._wage = wage
    }

    var body: some View {
        // This upper limit might seem high, but we also need to consider other currencies.
        Stepper(value: $wage, in: 0.5 ... 1_000_000, step: 0.5, format: .currency(code: currencyCode)) {
            HStack {
                Text(Strings.Settings.hourlyWage)
                Spacer()
                TextField(Strings.Settings.hourlyWage, value: $wage, format: .currency(code: currencyCode))
                    .multilineTextAlignment(.trailing)
                    .scrollDismissesKeyboard(.automatic)
                    .submitLabel(.done)
            }
        }
    }
}

struct WageStepper_Previews: PreviewProvider {
    static var previews: some View {
        WageStepper(wage: .constant(12))
    }
}
