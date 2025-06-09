// Copyright © 2025 Jonas Frey. All rights reserved.

public protocol DependencyInitializer: Sendable {
    @MainActor
    var didRegisterDependencies: Bool { get }

    func register() async
    func register(in context: DependencyContext) async
}
