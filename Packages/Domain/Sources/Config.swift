//
//  Config.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import Core
import Foundation
import SwiftUI

public class Config: ObservableObject {
    @AppStorage(UserDefaultsKey.wage)
    public var wage: Double = UserDefaultsDefaultValue.wage

    @AppStorage("currency")
    public var currency: String = "EUR"

    public init() {}
}
