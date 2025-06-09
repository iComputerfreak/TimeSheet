// Copyright © 2025 Jonas Frey. All rights reserved.

@propertyWrapper
public struct Injected<Value> {
    public var wrappedValue: Value {
        Container.current.resolve()
    }

    public init() {}
}
