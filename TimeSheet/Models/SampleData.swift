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
            let (h, m) = randomHours()
            worktimes.append(.init(date: randomDate(), activity: nil, hours: h, minutes: m, wage: randomWage()))
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
            let (h, m) = randomHours()
            payouts.append(.init(date: date, worktimes: [
                .init(date: date, activity: nil, hours: h, minutes: m, wage: randomWage())
            ]))
        }
        return payouts
    }
    
    static func randomWage() -> Double {
        Double(Int.random(in: 8...20))
    }
    
    static func randomHours() -> (Int, Int) {
        (Int.random(in: 0...10), Int.random(in: 0..<4) * 15)
    }
    
    static func randomDate() -> Date {
        let dateOffset = TimeInterval(Int.random(in: (-2 * 365)...0)) * TimeInterval.day
        return Date.now.addingTimeInterval(dateOffset)
    }
}
