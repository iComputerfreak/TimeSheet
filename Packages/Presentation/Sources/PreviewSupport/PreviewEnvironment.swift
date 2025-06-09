// Copyright © 2025 Jonas Frey. All rights reserved.

#if DEBUG

import Core
import Domain
import SwiftUI

// TODO: Make internal again, when all UI is moved here

public struct PreviewEnvironmentModifier: ViewModifier {
    @State private var dependencyInitializer: DependencyInitializer = PreviewDependencyInitializer()

    public func body(content: Content) -> some View {
        // Make sure to use the preview dependency container
        Container.$current.withValue(Container.preview) {
            Group {
                if dependencyInitializer.didRegisterDependencies {
                    content.environment(\.locale, Locale(identifier: "de"))
                } else {
                    Text(verbatim: "Loading preview environment...")
                        .task {
                            await dependencyInitializer.register()
                        }
                }
            }
        }
    }
}

public extension View {
    func previewEnvironment() -> some View {
        self.modifier(PreviewEnvironmentModifier())
    }
}

#endif
