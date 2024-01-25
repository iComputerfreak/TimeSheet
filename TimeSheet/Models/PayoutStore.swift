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
    
    @Published var payouts: [Payout]
    
    init(payouts: [Payout] = []) {
        self.payouts = payouts
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.payouts = try container.decode([Payout].self, forKey: .payouts)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.payouts, forKey: .payouts)
    }
    
    enum CodingKeys: CodingKey {
        case payouts
    }
}
