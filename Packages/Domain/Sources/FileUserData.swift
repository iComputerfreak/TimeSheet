//
//  UserData.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import Core
import Foundation
import Model
import SwiftUI

@Observable
public final class FileUserData: UserData {
    private let userDefaults: UserDefaults
    public var worktimes: [WorkTime]
    public var payouts: [Payout]

    public var totalWorkingDuration: DateComponents {
        worktimes
            .filter { !$0.isFixedPay }
            .filter { $0.pay > 0 }
            .map(\.duration)
            .reduce(.zero, +)
    }

    public var totalWorktimePayIncludingDebts: Double {
        worktimes
            .map(\.pay)
            .reduce(0, +)
    }

    public convenience init(worktimes: [WorkTime], payouts: [Payout]) {
        self.init(worktimes: worktimes, payouts: payouts, userDefaults: .standard)
    }

    public init(worktimes: [WorkTime], payouts: [Payout], userDefaults: UserDefaults) {
        self.worktimes = worktimes
        self.payouts = payouts
        self.userDefaults = userDefaults
    }

    public convenience init() {
        self.init(userDefaults: .standard)
    }

    // Load from persistent store
    public init(userDefaults: UserDefaults) {
        print("Loading persistent data...")
        self.worktimes = Self.decode([WorkTime].self, forKey: UserDefaultsKey.worktimes, from: userDefaults) ?? []
        self.payouts = Self.decode([Payout].self, forKey: UserDefaultsKey.payouts, from: userDefaults) ?? []
        self.userDefaults = userDefaults
        print("Loaded \(self.worktimes.count) worktimes and \(self.payouts.count) payouts.")
    }

    public func save() {
        print("Saving persistent data...")
        let encoder = PropertyListEncoder()
        do {
            userDefaults.set(try encoder.encode(self.worktimes), forKey: UserDefaultsKey.worktimes)
            userDefaults.set(try encoder.encode(self.payouts), forKey: UserDefaultsKey.payouts)
        } catch {
            print(error)
        }
    }
}

public extension FileUserData {
    static func decode<T: Decodable>(
        _ type: T.Type,
        forKey key: String,
        from userDefaults: UserDefaults = .standard
    ) -> T? {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        do {
            return try PropertyListDecoder().decode(type, from: data)
        } catch {
            print(error)
        }
        return nil
    }
}
