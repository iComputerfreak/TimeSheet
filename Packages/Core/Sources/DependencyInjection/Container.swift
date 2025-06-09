// Copyright © 2025 Jonas Frey. All rights reserved.

import Foundation

/// A dependency injection container that allows for registering and resolving dependencies.
///
/// This container uses a task-local variable to provide the current dependency container in the current task.
///
/// To resolve dependencies, use the static `current` property of `Container`.
///
/// If you need to do work that needs to be synchronized, e.g., resetting and re-registering dependencies, you can use
/// `Container.synchronize(_:)` to ensure that the work is done in a thread-safe and no registrations or resolutions are
/// executed in the mean time.
///
/// To use a different container, you can use `Container.$current.withValue(_:operation:)` to set a different container
/// for the current `Task`. This value is available inside the operation closure.
public final class Container: @unchecked Sendable { // We use `NSRecursiveLock` to ensure Sendable conformance
    /// The dependency container to use in the current task.
    @TaskLocal public static var current: Container = .live
    /// The live dependency container, containing the actual dependencies used in production.
    public static let live = Container()

    #if DEBUG
    /// A preview dependency container, used for SwiftUI Previews.
    public static let preview = Container()
    #endif

    private let lock: NSRecursiveLock = .init()
    private var registrations: [String: Any] = [:]

    // Allow creation of individual containers for testing
    public init() {}

    /// Registers a value for a specific type and an optional key.
    ///
    /// - Note: Registered dependencies are evaluated immediately and the instances stored in the container.
    public func register<Value>(_ type: Value.Type, key: (any DependencyKey)? = nil, _ value: @escaping () -> Value) {
        let keyString = keyString(for: Value.self, key: key)
        synchronize {
            registrations[keyString] = value()
        }
    }

    /// Resolves a value from the specific type and an optional key.
    public func resolve<Value>(key: (any DependencyKey)? = nil) -> Value {
        let keyString = keyString(for: Value.self, key: key)
        return synchronize {
            guard let value = registrations[keyString] as? Value else {
                fatalError(
                    "No registration found for type \(String(describing: Value.self)) and "
                    + "key \(key?.rawValue ?? "nil"). "
                    + "Available registrations: \(registrations.keys.joined(separator: ", "))"
                )
            }
            return value
        }
    }

    private func keyString<T>(for type: T.Type, key: (any DependencyKey)?) -> String {
        let typeDescription = String(describing: type)
        if let key {
            return "\(typeDescription).\(key.rawValue)"
        } else {
            return typeDescription
        }
    }
}

public extension Container {
    /// Synchronizes the execution of the provided work block, ensuring that no other registrations or resolutions
    /// are executed in the meantime.
    func synchronize<T>(_ work: () -> T) -> T {
        defer { lock.unlock() }
        lock.lock()

        return work()
    }
}
