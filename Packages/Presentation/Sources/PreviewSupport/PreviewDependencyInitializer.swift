// Copyright © 2025 Jonas Frey. All rights reserved.

import Core
import Domain
import Foundation

@Observable
public final class PreviewDependencyInitializer: DependencyInitializer {
    @MainActor
    public private(set) var didRegisterDependencies: Bool = false
    // A lock for ensuring thread-safe access to `didRegisterDependencies`
    private let lock: NSLock = .init()

    public init() {}

    public func register() async {
        await register(in: .current)
    }

    // TODO: Use mocks
    public func register(in container: Container) async {
        container.register(UserData.self) {
            SampleData.userData
        }

        container.register(Config.self) {
            Config()
        }

        await MainActor.run {
            didRegisterDependencies = true
        }
    }
}
