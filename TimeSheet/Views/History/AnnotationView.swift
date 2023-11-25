//
//  AnnotationView.swift
//  TimeSheet
//
//  Created by Jonas Frey on 10.06.22.
//

import SwiftUI

struct AnnotationView: View {
    static var durationFormatter: DateComponentsFormatter {
        let f = DateComponentsFormatter()
        f.allowedUnits = [.hour, .minute]
        f.unitsStyle = .abbreviated
        return f
    }
    
    @EnvironmentObject private var config: Config
    let date: Date
    let value: Double
    let graphType: GraphType
    
    var monthName: String {
        Calendar.current.monthSymbols[date.month - 1]
    }
    
    var valueLabel: String {
        switch graphType {
        case .income:
            return value.formatted(.currency(code: config.currency))
        case .time:
            let comp = DateComponents(hour: Int(value), minute: Int(value * 60) % 60)
            return Self.durationFormatter.string(from: comp) ?? ""
        }
    }
    
    var body: some View {
        VStack {
            Text("\(monthName)")
            Text(valueLabel)
        }
            .padding(8)
            .background(
                .quaternary.opacity(0.8)
            )
            .cornerRadius(5)
    }
}

struct AnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        AnnotationView(date: .now, value: 100, graphType: .income)
            .padding()
            .previewLayout(.sizeThatFits)
            .environmentObject(Config())
    }
}
