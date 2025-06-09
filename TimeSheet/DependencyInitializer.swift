// Copyright © 2025 Jonas Frey. All rights reserved.

import Core
import Domain
import Foundation

@Observable
public final class DependencyInitializer {
    private let container: Container = .current

    public private(set) var didRegisterDependencies: Bool = false

    public init() {}

    public func register() async {
        container.register(UserData.self) {
            UserData()
        }

        didRegisterDependencies = true
    }
}
