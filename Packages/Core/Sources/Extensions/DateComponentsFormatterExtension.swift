// Copyright © 2025 Jonas Frey. All rights reserved.

import Foundation

public extension DateComponentsFormatter {
    convenience init(allowedUnits: NSCalendar.Unit?, unitsStyle: DateComponentsFormatter.UnitsStyle?) {
        self.init()

        if let allowedUnits {
            self.allowedUnits = allowedUnits
        }

        if let unitsStyle {
            self.unitsStyle = unitsStyle
        }
    }
}
