// Copyright © 2025 Jonas Frey. All rights reserved.

#if DEBUG

import Core
import Domain
import SwiftUI

extension View {
    func previewEnvironment() -> some View {
        // Make sure to use the preview dependency container
        Container.$current.withValue(Container.preview) {
            self
                .environmentObject(Config())
                .environmentObject(UserData())
                .environment(\.locale, Locale(identifier: "de"))
        }
    }
}

#endif
