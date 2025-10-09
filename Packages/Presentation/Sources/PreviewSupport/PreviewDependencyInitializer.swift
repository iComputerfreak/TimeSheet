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

    public func register(in context: DependencyContext) async {
        let mockUserData = await MockUserData(
            workTimes: SampleData.generateWorkTimes(),
            payouts: SampleData.generatePayouts()
        )
        context.register(UserData.self) { mockUserData }

        context.register(Config.self) {
            Config()
        }

        await MainActor.run {
            didRegisterDependencies = true
        }
    }
}
