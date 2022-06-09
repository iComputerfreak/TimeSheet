//
//  WorkTime.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import Foundation

struct WorkTime: Identifiable, Codable {
    static let durationFormatter: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.unitsStyle = .abbreviated
        f.allowedUnits = [.hour, .minute]
        return f
    }()
    
    var id = UUID()
    var date: Date
    var duration: DateComponents
    
    init(date: Date, duration: DateComponents) {
        self.date = date
        self.duration = duration
    }
    
    init(date: Date, hours: Double) {
        let h = Int(hours)
        let m = Int(hours * 60) % 60
        self.init(date: date, duration: DateComponents(hour: h, minute: m))
    }
}

extension DateComponents {
    func pay(using wage: Double) -> Double {
        var hours: Double = Double(self.hour ?? 0)
        hours += Double(self.minute ?? 0) / 60
        return hours * wage
    }
}
