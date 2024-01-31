//
//  SettingsView.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import SwiftUI
import JFUtils

struct SettingsView: View {
    
    @EnvironmentObject private var config: Config
    #if DEBUG
    @EnvironmentObject private var userData: UserData
    #endif
    
    @State private var exportComment: String = ""
    @State private var timeFrame: TimeFrame = .everything
    
    enum TimeFrame: Hashable {
        case everything
        case from(startDate: Date)
        case upTo(endDate: Date)
        case between(startDate: Date, endDate: Date)
        case month(year: Int, month: Int)
        
        var startDate: Date? {
            get {
                switch self {
                case .everything, .upTo:
                    return nil
                case .from(let startDate), .between(let startDate, _):
                    return startDate
                case .month(year: let year, month: let month):
                    return Date.create(year, month, 1)
                }
            }
            set {
                // TODO: Implement
            }
        }
        
        var endDate: Date? {
            get {
                switch self {
                case .everything, .from:
                    return nil
                case .upTo(let endDate), .between(_, let endDate):
                    return endDate
                case .month(year: let year, month: let month):
                    // The last day of the given month is the 0-th day of the next one
                    return Date.create(year, month + 1, 0)
                }
            }
            set {
                // TODO: Implement
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                WageStepper(wage: $config.wage)
                Picker("Currency", selection: $config.currency) {
                    ForEach(Locale.commonISOCurrencyCodes, id: \.self) { code in
                        Text(code)
                    }
                }
                #if DEBUG
                if userData.worktimes.isEmpty {
                    Button("Generate Screenshot Data") {
                        userData.worktimes = SampleData.screenshotWorktimes
                        userData.payouts = SampleData.screenshotPayouts
                    }
                }
                #endif
                
                Section {
                    TextField(text: $config.exportName) {
                        Text("Your Name")
                    }
                    TextField(text: $exportComment) {
                        Text("Comment")
                    }
                    Picker(selection: $timeFrame) {
                        Text("Everything")
                            .tag(TimeFrame.everything)
                        Text("From...")
                            .tag(
                                TimeFrame.from(
                                    startDate: userData.worktimes.min(on: \.date, by: <)?.date ?? .now
                                )
                            )
                        Text("Up to...")
                            .tag(
                                TimeFrame.upTo(
                                    endDate: userData.worktimes.max(on: \.date, by: <)?.date ?? .now
                                )
                            )
                        Text("Between...")
                            .tag(
                                TimeFrame.between(
                                    startDate: userData.worktimes.min(on: \.date, by: <)?.date ?? .now,
                                    endDate: userData.worktimes.max(on: \.date, by: <)?.date ?? .now
                                )
                            )
                        let minYear = userData.worktimes.min(on: \.date.year, by: <)?.date.year ?? Date.now.year
                        Text("Month...")
                            .tag(
                                TimeFrame.month(
                                    year: minYear,
                                    month: userData.worktimes
                                        .filter({ $0.date.year == minYear })
                                        .min(on: \.date.month, by: <)?.date.month ?? Date.now.month
                                )
                            )
                    } label: {
                        Text("Range")
                    }
                    if case let .month(year, month) = timeFrame {
                        // TODO: Move into own view
                        // Special handling for months
                        let years = Set(userData.worktimes.map(\.date.year)).sorted(by: <)
                        let months: [Int: [Int]] = Dictionary(grouping: userData.worktimes.map(\.date), by: \.year)
                            .mapValues { dates in
                                dates.map(\.month)
                            }
                        // TODO: Bindings or property to change year/month on timeFrame
                        // TODO: Picker with years
                        Picker(selection: <#T##Binding<Hashable>#>, content: <#T##() -> View#>, label: <#T##() -> View#>)
                        // TODO: Picker with months (for year) resolved as month names
                    } else {
                        if let startDateBinding = Binding($timeFrame.startDate) {
                            DatePicker(selection: startDateBinding, displayedComponents: .date) {
                                Text("Start Date")
                            }
                        }
                        if let endDateBinding = Binding($timeFrame.endDate) {
                            DatePicker(selection: endDateBinding, displayedComponents: .date) {
                                Text("End Date")
                            }
                        }
                    }
                    Button {
                        // TODO: Use the name and comment
                        let exporter = PDFExporter()
                        do {
                            let pdf = try exporter.export(
                                userData.worktimes,
                                startDate: timeFrame.startDate,
                                endDate: timeFrame.endDate
                            )
                            // TODO: Open the PDF in QuickLook or share it immediately
                        } catch {
                            print(error)
                            AlertHandler.showError(
                                title: String(
                                    localized: "Error Generating PDF",
                                    comment: "The alert title when informing the user about an error during PDF export"
                                ),
                                error: error
                            )
                        }
                    } label: {
                        Text("Generate PDF", comment: "The label for the export button in the settings")
                    }
                } header: {
                    Text("PDF Export")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environment(\.locale, Locale(identifier: "de"))
            .environmentObject(Config())
            .environmentObject(UserData())
    }
}
