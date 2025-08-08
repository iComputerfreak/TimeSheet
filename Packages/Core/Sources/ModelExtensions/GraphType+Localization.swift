// Copyright © 2025 Jonas Frey. All rights reserved.

import Model

public extension GraphType {
    var yLabel: String {
        switch self {
        case .income:
            Strings.History.GraphType.income

        case .time:
            Strings.History.GraphType.time
        }
    }
}
