//
//  AddWorkTimeView.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import SwiftUI

struct AddWorkTimeView: View {
    let minuteSteps = 5
    
    // TODO: Use
    enum Mode {
        case editing
        case adding
    }
    
    @EnvironmentObject private var config: Config
    @State private var date: Date
    @State private var activity: String
    @State private var hours: Int
    @State private var minutes: Int
    @State private var wage: Double
    @State private var dateChanged = false
    // TODO: Replace with query?
    private var worktimes: Binding<[WorkTime]>?
    private var editingItem: WorkTime?
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var zeroHoursShowing = false
    
    @State private var dateRange = Date().addingTimeInterval(lowestValidNegativeDateInterval) ... Date()
    
    /// Creates a new AddWorkTimeView in either adding mode, adding a new work time item on save
    /// - Parameter worktimes: The list of worktimes to append the new object at
    init(worktimes: Binding<[WorkTime]>) {
        self.worktimes = worktimes
        self.editingItem = nil
        self._date = State(wrappedValue: Date())
        self._activity = State(wrappedValue: "")
        self._hours = State(wrappedValue: 0)
        self._minutes = State(wrappedValue: 0)
        self._wage = State(wrappedValue: 0)
    }
    
    /// Creates a new AddWorkTimeView in editing mode, editing the given `editingItem`
    /// - Parameter editingItem: The work time being edited
    init(editingItem: WorkTime) {
        self.worktimes = nil
        self.editingItem = editingItem
        
        // Pre-fill the values with the ones of the editingItem
        let worktime = editingItem
        self._activity = State(wrappedValue: worktime.activity ?? "")
        self._date = State(wrappedValue: worktime.date)
        self._hours = State(wrappedValue: Int(worktime.duration / .hour))
        self._minutes = State(wrappedValue: Int(worktime.duration.truncatingRemainder(dividingBy: .hour) / .minute))
        self._wage = State(wrappedValue: worktime.wage)
    }
    
    var body: some View {
        Form {
            TextField("Activity (optional)", text: $activity)
            DatePicker(selection: $date, in: dateRange, displayedComponents: .date) {
                Text("Date")
            }
            .onChange(of: date) {
                // Mark the date as manually changed
                self.dateChanged = true
            }
            .onAppear {
                self.dateRange = Date().addingTimeInterval(lowestValidNegativeDateInterval) ... Date()
                // If the user did not change the date himself, reset it to "today"
                // This works around the bug that the date seems to be stuck on old values when opening the app after a few days
                // TODO: DEBUG by putting an exact date in the form and observing if it changes when cancelling and reopening the view
                if !self.dateChanged {
                    self.date = Date()
                }
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
                // TODO: mode == Adding
                if let worktimes {
                    let newItem = WorkTime(
                        date: date,
                        activity: activity.isEmpty ? nil : activity,
                        hours: hours,
                        minutes: minutes,
                        wage: wage
                    )
                    modelContext.insert(newItem)
                    // TODO: mode == Editing
                } else if let editingItem {
                    // Update the existing item
                    editingItem.date = date
                    editingItem.activity = activity.isEmpty ? nil : activity
                    editingItem.duration = Double(hours) * .hour + Double(minutes) * .minute
                    editingItem.wage = wage
                } else {
                    assertionFailure("AddWorkTimeView was created with neither a list of worktimes, nor an editingItem.")
                }
                self.dateChanged = false
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
