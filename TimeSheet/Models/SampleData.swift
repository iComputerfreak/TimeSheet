//
//  SampleData.swift
//  TimeSheet
//
//  Created by Jonas Frey on 10.06.22.
//

import Foundation

struct SampleData {
    static let userData: UserData = {
        UserData(
            worktimes: generateWorkTimes(),
            payouts: generatePayouts()
        )
    }()
    
    static func generateWorkTimes(count: Int = 80) -> [WorkTime] {
        var worktimes: [WorkTime] = []
        for _ in 1...count {
            worktimes.append(.init(date: randomDate(), activity: nil, hours: randomHours(), wage: randomWage()))
        }
        return worktimes
    }
    
    static func generatePayouts(count: Int = 5) -> [Payout] {
        var payouts: [Payout] = []
        var date: Date = .now
        for _ in 1...count {
            // Payouts should lie in the past and should be at least 7 days distance from each other
            let offset = -TimeInterval(Int.random(in: 7...21)) * .day
            date.addTimeInterval(offset)
            payouts.append(.init(date: date, worktimes: [
                .init(date: date, activity: nil, hours: randomHours(), wage: randomWage())
            ]))
        }
        return payouts
    }
    
    static func randomWage() -> Double {
        Double(Int.random(in: 8...20))
    }
    
    static func randomHours() -> Double {
        Double(Int.random(in: 0...(4 * 10))) / 4
    }
    
    static func randomDate() -> Date {
        let dateOffset = TimeInterval(Int.random(in: (-2 * 365)...0)) * TimeInterval.day
        return Date.now.addingTimeInterval(dateOffset)
    }
}
