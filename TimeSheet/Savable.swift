//
//  Savable.swift
//  TimeSheet
//
//  Created by Jonas Frey on 25.01.24.
//

import Foundation
import OSLog

/// Represents an entity that can be persisted on disk and loaded from disk again
protocol Savable: Codable {
    /// A logger associated with this entity
    static var logger: Logger { get }
    /// The URL where to persist the entity
    static var dataPath: URL { get }
    /// Whether the entity was created as in-memory and should therefore not be saved to disk
    var inMemory: Bool { get }
    /// Loads the entity from disk
    static func load() throws -> Self
    /// Tries to save the entity to disk, logging errors to the logger
    func trySave() throws
    /// Persists the entity to disk, logging any errors
    func save()
    /// Creates a new empty instance
    /// - Parameter inMemory: Whether the instance should be created as in-memory without being able to be saved
    init(inMemory: Bool)
}

extension Savable {
    /// Decodes the data stored at the `dataPath` and returns the decoded object of type `Self`.
    static func tryLoad() throws -> Self {
        guard FileManager.default.fileExists(atPath: dataPath.path()) else {
            // No data available on disk, so we can create a new file
            let newObject = Self(inMemory: false)
            do {
                try newObject.trySave()
            } catch {
                logger.warning("Error trying to save the default config to disk: \(error)")
                // We don't need to throw the error again, as this error is not critical.
                // We can continue with a config in memory
            }
            return newObject
        }
        // If the file exists, but we cannot read it, throw an error
        let data = try Data(contentsOf: dataPath)
        return try JSONDecoder().decode(Self.self, from: data)
    }
    
    static func load() -> Self {
        do {
            return try tryLoad()
        } catch {
            logger.error("Error during loading persistent data: \(error). Falling back to a new in-memory instance.")
            return Self.init(inMemory: true)
        }
    }
    
    /// Encodes this object into JSON data and writes it to the `dataPath` and throws any errors that occur during saving.
    func trySave() throws {
        // Do not save in-memory instances
        guard !inMemory else {
            return
        }
        let data = try JSONEncoder().encode(self)
        try data.write(to: Self.dataPath)
    }
    
    /// Encodes this object into JSON data and writes it to the `dataPath` and logs any errors that occur during saving.
    func save() {
        do {
            try trySave()
        } catch {
            Self.logger.error("Error saving \(String(describing: Self.self)): \(error)")
        }
    }
}
