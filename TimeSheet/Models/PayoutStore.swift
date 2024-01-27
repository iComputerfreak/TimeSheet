//
//  PayoutStore.swift
//  TimeSheet
//
//  Created by Jonas Frey on 25.01.24.
//

import Foundation
import SwiftUI
import OSLog

class PayoutStore: ObservableObject, Codable, Savable {
    static let logger: Logger = .init(category: "PayoutStore")
    static let dataPath: URL = Utils.documentsDirectoryURL().appending(component: "payoutStore.json")
    
    let inMemory: Bool
    @Published var payouts: [Payout]
    
    init(inMemory: Bool = false, payouts: [Payout] = []) {
        self.payouts = payouts
        self.inMemory = inMemory
    }
    
    required convenience init(inMemory: Bool) {
        self.init(inMemory: inMemory, payouts: [])
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.payouts = try container.decode([Payout].self, forKey: .payouts)
        // Loaded entities are never in-memory
        self.inMemory = false
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.payouts, forKey: .payouts)
    }
    
    enum CodingKeys: CodingKey {
        case payouts
    }
}
