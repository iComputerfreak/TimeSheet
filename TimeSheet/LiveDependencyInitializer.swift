// Copyright © 2025 Jonas Frey. All rights reserved.

import Core
import Domain
import Foundation

@Observable
public final class LiveDependencyInitializer: DependencyInitializer {
    @MainActor
    public private(set) var didRegisterDependencies: Bool = false

    public init() {}

    public func register() async {
        await register(in: .current)
    }

    public func register(in container: Container) async {
        container.register(UserData.self) {
            UserData()
        }

        container.register(Config.self) {
            Config()
        }

        await MainActor.run {
            didRegisterDependencies = true
        }
    }
}
