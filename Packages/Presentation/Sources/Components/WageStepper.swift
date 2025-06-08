//
//  WageStepper.swift
//  TimeSheet
//
//  Created by Jonas Frey on 10.06.22.
//

import Core
import SwiftUI

public struct WageStepper: View {
    @AppStorage(UserDefaultsKey.currency)
    private var currencyCode: String = UserDefaultsDefaultValue.currency

    @Binding private var wage: Double

    // swiftlint:disable:next type_contents_order
    public init(wage: Binding<Double>) {
        self._wage = wage
    }

    public var body: some View {
        Stepper(value: $wage, in: 0...100, step: 0.5, format: .currency(code: currencyCode)) {
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
