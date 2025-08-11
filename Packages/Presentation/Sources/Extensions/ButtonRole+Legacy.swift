// Copyright © 2025 Jonas Frey. All rights reserved.

import SwiftUI

public extension ButtonRole {
    static var legacyConfirm: ButtonRole? {
        if #available(iOS 26.0, *) {
            return .confirm
        } else {
            return nil
        }
    }

    static var legacyClose: ButtonRole? {
        if #available(iOS 26.0, *) {
            return .close
        } else {
            return .cancel
        }
    }
}
