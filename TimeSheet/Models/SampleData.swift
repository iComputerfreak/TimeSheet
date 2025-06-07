//
//  SampleData.swift
//  TimeSheet
//
//  Created by Jonas Frey on 10.06.22.
//

import Foundation

enum SampleData {
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

    private static let screenshotWage: Double = 20
    static let screenshotWorktimes: [WorkTime] = [
        WorkTime(
            date: Date.create(2022, 11, 12),
            activity: "Redesign of personal website",
            hours: 7,
            minutes: 0,
            wage: screenshotWage
        ),
        WorkTime(
            date: Date.create(2022, 11, 15),
            activity: "Creation of online store",
            hours: 8,
            minutes: 0,
            wage: screenshotWage
        ),
        WorkTime(
            date: Date.create(2022, 11, 23),
            activity: "Design of email newsletter",
            hours: 2,
            minutes: 45,
            wage: screenshotWage
        ),
        WorkTime(
            date: Date.create(2022, 12, 05),
            activity: "Logo revision",
            hours: 1,
            minutes: 0,
            wage: screenshotWage
        ),
        WorkTime(
            date: Date.create(2022, 12, 18),
            activity: "Consultation call",
            hours: 0,
            minutes: 30,
            wage: screenshotWage
        ),
        WorkTime(
            date: Date.create(2023, 01, 02),
            activity: "Ask ChatGPT for sample data",
            hours: 0,
            minutes: 15,
            wage: screenshotWage
        )
    ]

    private static let screenshotPayoutsData: [(Date, Double)] = [
        (Date.create(2022, 10, 01), 1250.0),
        (Date.create(2022, 09, 01), 1750.0),
        (Date.create(2022, 08, 01), 2250.0),
        (Date.create(2022, 05, 01), 500.0),
        (Date.create(2022, 04, 01), 3000.0)
    ]
    static var screenshotPayouts: [Payout] {
        screenshotPayoutsData.map { date, amount in
            let hours = amount / screenshotWage
            let minutes = amount.truncatingRemainder(dividingBy: screenshotWage) / (screenshotWage / 60)
            return Payout(
                date: date,
                worktimes: [
                    WorkTime(date: date, activity: nil, hours: Int(hours), minutes: Int(minutes), wage: screenshotWage)
                ]
            )
        }
    }
}

extension Date {
    static func create(_ year: Int, _ month: Int, _ day: Int) -> Date {
        Calendar.current.date(from: .init(year: year, month: month, day: day))!
    }
}
