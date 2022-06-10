//
//  WageStepper.swift
//  TimeSheet
//
//  Created by Jonas Frey on 10.06.22.
//

import SwiftUI

struct WageStepper: View {
    @Binding var wage: Double
    
    var body: some View {
        Stepper(value: $wage, in: 0...100, step: 0.5, format: .currency(code: "EUR")) {
            HStack {
                Text("Hourly wage")
                Spacer()
                Text(wage.formatted(.currency(code: "EUR")))
            }
        }
    }
}

struct WageStepper_Previews: PreviewProvider {
    static var previews: some View {
        WageStepper(wage: .constant(12))
    }
}
