//
//  AddWorkTimeView.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import SwiftUI

extension TimeInterval {
    static let year: TimeInterval = 365 * .day
    static let day: TimeInterval = 24 * .hour
    static let hour: TimeInterval = 60 * .minute
    static let minute: TimeInterval = 60
    
}

struct AddWorkTimeView: View {
    @State private var date = Date.now
    @State private var hours: Double = 0
    @Binding var worktimes: [WorkTime]
    @Environment(\.dismiss) private var dismiss
    
    let dateRange = Date.now.addingTimeInterval(-100 * .year) ... Date.now
    
    var body: some View {
        Form {
            DatePicker(selection: $date, in: dateRange, displayedComponents: .date) {
                Text("Date")
            }
            Stepper(value: $hours, in: 0...24, step: 0.25) {
                HStack {
                    Text("Hours")
                    Spacer()
                    Text("\(hours, format: .number.precision(.fractionLength(0...2)))")
                }
            }
        }
        .navigationTitle("Add Entry")
        .toolbar {
            Button("Save") {
                worktimes.append(.init(date: date, hours: hours))
                dismiss()
            }
        }
    }
}

struct AddWorkTimeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddWorkTimeView(worktimes: .constant([]))
        }
    }
}
