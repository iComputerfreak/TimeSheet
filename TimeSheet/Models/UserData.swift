//
//  UserData.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import Foundation
import SwiftUI

class UserData: ObservableObject {
    static private let worktimesKey = "worktimes"
    static private let payoutsKey = "payouts"
    
    @Published var worktimes: [WorkTime]
    @Published var payouts: [Payout]
    
    var totalWorkingDuration: DateComponents {
        worktimes
            .filter { !$0.isFixedPay }
            // Do not include payouts (negative pay)
            .filter { $0.pay > 0 }
            .map(\.duration)
            .reduce(.zero, +)
    }
    
    var totalWorktimePay: Double {
        worktimes
            .map(\.pay)
            // Do not include payouts (negative values)
            .filter { $0 > 0 }
            .reduce(0, +)
    }
    
    init(worktimes: [WorkTime], payouts: [Payout]) {
        self.worktimes = worktimes
        self.payouts = payouts
    }
    
    // Load from persistent store
    init() {
        print("Loading persistent data...")
        self.worktimes = Self.decode([WorkTime].self, forKey: Self.worktimesKey) ?? []
        self.payouts = Self.decode([Payout].self, forKey: Self.payoutsKey) ?? []
    }
    
    func save() {
        print("Saving persistent data...")
        let encoder = PropertyListEncoder()
        do {
            UserDefaults.standard.set(try encoder.encode(self.worktimes), forKey: Self.worktimesKey)
            UserDefaults.standard.set(try encoder.encode(self.payouts), forKey: Self.payoutsKey)
        } catch {
            print(error)
        }
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
}
