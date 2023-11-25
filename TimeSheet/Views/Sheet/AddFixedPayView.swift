//
//  AddFixedPayView.swift
//  TimeSheet
//
//  Created by Jonas Frey on 27.10.22.
//

import SwiftUI

struct AddFixedPayView: View {
    @EnvironmentObject private var config: Config
    @State private var date = Date.now
    @State private var activity: String = ""
    @State private var payAmount: Double = 0
    private var worktimes: Binding<[WorkTime]>?
    private var editingItem: Binding<WorkTime>?
    @Environment(\.dismiss) private var dismiss
    
    @State private var zeroHoursShowing = false
    
    let dateRange: ClosedRange<Date>
    
    private init() {
        self._date = State(wrappedValue: Date())
        self.dateRange = Date().addingTimeInterval(lowestValidNegativeDateInterval) ... Date()
    }
    
    /// Creates a new AddWorkTimeView in either adding mode, adding a new work time item on save
    /// - Parameter worktimes: The list of worktimes to append the new object at
    init(worktimes: Binding<[WorkTime]>) {
        self.init()
        self.worktimes = worktimes
        self.editingItem = nil
    }
    
    /// Creates a new AddWorkTimeView in editing mode, editing the given `editingItem`
    /// - Parameter editingItem: The work time being edited
    init(editingItem: Binding<WorkTime>) {
        self.init()
        self.worktimes = nil
        self.editingItem = editingItem
        
        // Pre-fill the values with the ones of the editingItem
        let worktime = editingItem.wrappedValue
        self.activity = worktime.activity ?? ""
        self.date = worktime.date
        self.payAmount = worktime.pay
    }
    
    var body: some View {
        Form {
            TextField("Activity (optional)", text: $activity)
            DatePicker(selection: $date, in: dateRange, displayedComponents: .date) {
                Text("Date")
            }
            HStack {
                Text("Amount")
                Spacer(minLength: 50)
                TextField("Amount", value: $payAmount, format: .number.precision(.fractionLength(0...2)))
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                    .toolbar {
                        ToolbarItem(placement: .keyboard) {
                            HStack {
                                Button {
                                    self.payAmount *= -1
                                } label: {
                                    Text("+/-")
                                        .padding(.horizontal, 4)
                                        .padding(.bottom, 2)
                                        .background {
                                            RoundedRectangle(cornerRadius: 3)
                                                .fill(Color("secondaryAccent"))
                                        }
                                }
                                Spacer()
                            }
                            Button("Test") {
                                print("Pressed.")
                            }
                        }
                    }
            }
        }
        .navigationTitle("Add Entry")
        .toolbar {
            Button("Save") {
                guard payAmount != 0 else {
                    zeroHoursShowing = true
                    return
                }
                var newItem = WorkTime(
                    date: date,
                    activity: activity.isEmpty ? nil : activity,
                    fixedPay: payAmount
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
            .disabled(payAmount == 0)
        }
        .alert("Amount missing", isPresented: $zeroHoursShowing) {
            Button("Ok") {}
        } message: {
            Text("Please specify a pay amount.")
        }

    }
}

struct AddFixedPayView_Previews: PreviewProvider {
    static var previews: some View {
        AddFixedPayView(worktimes: .constant([]))
    }
}
