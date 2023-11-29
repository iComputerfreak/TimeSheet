//
//  Config.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import Foundation
import SwiftUI

class Config: ObservableObject {
    @AppStorage("wage")
    var wage: Double = 12.0
    
    // TODO: Default value should depend on region/locale settings
    @AppStorage("currency")
    var currency: String = "EUR"
}
