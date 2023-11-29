//
//  UserData.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import Foundation
import SwiftUI

class UserData: ObservableObject {
    static let migrationKey = "migratedToSwiftData"
    
    @Published var worktimes: [WorkTime] = []
    @Published var payouts: [Payout] = []
    
    var totalWorktimePayIncludingDebts: Double {
        worktimes
            .map(\.pay)
            .reduce(0, +)
    }
    
    init(worktimes: [WorkTime], payouts: [Payout]) {
        self.worktimes = worktimes
        self.payouts = payouts
    }
    
    // Load from persistent store
    init() {
        print("Loading persistent data...")
        if !UserDefaults.standard.bool(forKey: Self.migrationKey) {
            print("Migrating legacy data...")
            Self.migrateLegacyData()
            UserDefaults.standard.set(true, forKey: Self.migrationKey)
        }
    }
    
    func save() {
        print("Saving persistent data...")
    }
    
    static func decode<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return nil
        }
        do {
            return try PropertyListDecoder().decode(type, from: data)
        } catch {
            print(error)
        }
        return nil
    }
    
    static func migrateLegacyData() {
        let worktimesKey = "worktimes"
        let payoutsKey = "payouts"
        let legacyWorktimes = Self.decode([LegacyWorkTime].self, forKey: worktimesKey)
        let legacyPayouts = Self.decode([LegacyPayout].self, forKey: payoutsKey)
        if legacyWorktimes == nil && legacyPayouts == nil {
            // No data to restore, returning
            return
        }
        // Migrate the models to the new Swift Data models and insert them into the context
        print("Migrating \(legacyWorktimes?.count ?? 0) work times and \(legacyPayouts?.count ?? 0) payouts...")
        // TODO: ...
    }
}
