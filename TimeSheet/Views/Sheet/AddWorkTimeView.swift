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
    let minuteSteps = 5
    
    @EnvironmentObject private var config: Config
    @State private var date = Date.now
    @State private var activity: String = ""
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @State private var wage: Double = 0
    private var worktimes: Binding<[WorkTime]>?
    private var editingItem: Binding<WorkTime>?
    @Environment(\.dismiss) private var dismiss
    
    @State private var zeroHoursShowing = false
    
    @State private var dateRange = Date().addingTimeInterval(lowestValidNegativeDateInterval) ... Date()
    
    /// Creates a new AddWorkTimeView in either adding mode, adding a new work time item on save
    /// - Parameter worktimes: The list of worktimes to append the new object at
    init(worktimes: Binding<[WorkTime]>) {
        self.worktimes = worktimes
        self.editingItem = nil
    }
    
    /// Creates a new AddWorkTimeView in editing mode, editing the given `editingItem`
    /// - Parameter editingItem: The work time being edited
    init(editingItem: Binding<WorkTime>) {
        self.worktimes = nil
        self.editingItem = editingItem
        
        // Pre-fill the values with the ones of the editingItem
        let worktime = editingItem.wrappedValue
        self.activity = worktime.activity ?? ""
        self.date = worktime.date
        self.hours = worktime.duration.hour ?? 0
        self.minutes = worktime.duration.minute ?? 0
        self.wage = worktime.wage
    }
    
    var body: some View {
        Form {
            TextField("Activity (optional)", text: $activity)
            DatePicker(selection: $date, in: dateRange, displayedComponents: .date) {
                Text("Date")
            }
            .onAppear {
                self.dateRange = Date().addingTimeInterval(lowestValidNegativeDateInterval) ... Date()
            }
            Stepper(value: $hours, in: 0...23) {
                HStack {
                    Text("Hours")
                    Spacer()
                    Text(hours.formatted())
                }
            }
            Stepper(value: $minutes, in: 0...55, step: 5) {
                HStack {
                    Text("Minutes")
                    Spacer()
                    Text(minutes.formatted())
                }
            }
            WageStepper(wage: $wage)
        }
        .navigationTitle("Add Entry")
        .toolbar {
            Button("Save") {
                guard hours > 0 || minutes > 0 else {
                    zeroHoursShowing = true
                    return
                }
                var newItem = WorkTime(
                    date: date,
                    activity: activity.isEmpty ? nil : activity,
                    hours: hours,
                    minutes: minutes,
                    wage: wage
                )
                if let worktimes {
                    worktimes.wrappedValue.append(newItem)
                } else if let editingItem {
                    // Keep the old id
                    newItem.id = editingItem.wrappedValue.id
                    editingItem.wrappedValue = newItem
                } else {
                    assertionFailure("AddWorkTimeView was created with neither a list of worktimes, nor an editingItem.")
                }
                dismiss()
            }
            .disabled(hours == 0 && minutes == 0)
        }
        .onAppear {
            if self.editingItem == nil {
                self.wage = config.wage
            }
        }
        .alert("Hours missing", isPresented: $zeroHoursShowing) {
            Button("Ok") {}
        } message: {
            Text("Please specify how many hours you worked.")
        }

    }
}

struct AddWorkTimeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddWorkTimeView(worktimes: .constant([]))
                .environmentObject(Config())
        }
    }
}
