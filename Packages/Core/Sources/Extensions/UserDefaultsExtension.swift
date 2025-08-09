// Copyright © 2025 Jonas Frey. All rights reserved.

import Foundation

public extension UserDefaults {
    /// Creates a new `UserDefaults` instance for testing purposes.
    ///
    /// By default, this `UserDefaults` suite uses the file and function name of the caller to create a unique suite
    /// name that is stable across test runs.
    ///
    /// - Important: The caller is responsible to ensure that the `fileName` and `functionName` parameters are unique
    ///              across all test cases to avoid conflicts. Make sure to not call this function in the test suite's
    ///              initializer, but instead in the test case directly!
    ///
    /// - Parameters:
    ///   - fileName: The name of the file where this function is called.
    ///   - functionName: The name of the function where this function is called.
    /// - Returns: A new and empty `UserDefaults` instance with a unique suite name based on the caller's file and
    ///            function name.
    static func testing(fileName: String = #file, functionName: String = #function) -> UserDefaults {
        let suiteName = "\(fileName).\(functionName)"
        // Remove the existing suite (from previous executions)
        UserDefaults.standard.removePersistentDomain(forName: suiteName)
        // Create a new suite with the given name
        UserDefaults.standard.addSuite(named: suiteName)
        return UserDefaults(suiteName: suiteName) ?? .standard
    }
}
