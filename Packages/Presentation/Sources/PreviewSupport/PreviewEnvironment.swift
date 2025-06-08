// Copyright © 2025 Jonas Frey. All rights reserved.

#if DEBUG

import Domain
import SwiftUI

extension View {
    func previewEnvironment() -> some View {
        self
            .environmentObject(Config())
            .environmentObject(UserData())
            .environment(\.locale, Locale(identifier: "de"))
    }
}

#endif
