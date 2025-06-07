//
//  WageStepper.swift
//  TimeSheet
//
//  Created by Jonas Frey on 10.06.22.
//

import SwiftUI

struct WageStepper: View {
    @EnvironmentObject private var config: Config
    @Binding var wage: Double

    var body: some View {
        Stepper(value: $wage, in: 0...100, step: 0.5, format: .currency(code: config.currency)) {
            HStack {
                Text("Hourly wage")
                Spacer()
                TextField("Wage", value: $wage, format: .currency(code: config.currency))
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
