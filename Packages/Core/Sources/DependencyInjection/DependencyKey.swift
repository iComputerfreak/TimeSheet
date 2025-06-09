// Copyright © 2025 Jonas Frey. All rights reserved.

/// A protocol that defines a key for dependency injection.
///
/// Example:
/// ```swift
/// enum HTTPClientKey: String, DependencyKey {
///    case authentication
///    case userService
/// }
/// ```
public protocol DependencyKey: Sendable, RawRepresentable<String> {}
