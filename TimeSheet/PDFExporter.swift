//
//  PDFExporter.swift
//  TimeSheet
//
//  Created by Jonas Frey on 27.01.24.
//

import Foundation
import TPPDF
import JFUtils

class PDFExporter: ExporterProtocol {
//    let pdfFormat: UIGraphicsPDFRendererFormat = {
//        let pdfMetaData = [
//            kCGPDFContextCreator: "TimeSheet for iOS",
//            kCGPDFContextAuthor: "jonasfrey.de"
//        ]
//        
//        let format = UIGraphicsPDFRendererFormat()
//        format.documentInfo = pdfMetaData as [String: Any]
//        return format
//    }()
    
    static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .short // e.g., 01.01.2023
        return f
    }()
    
    private let dateFormat: Date.FormatStyle = .init(date: .numeric, time: .omitted)
    
    let footerFontSize: CGFloat = 8
    let bodyFontSize: CGFloat = 12
    
    func export(_ worktimes: [WorkTime], startDate: Date? = nil, endDate: Date? = nil) throws -> URL {
        let document = PDFDocument(format: .a4)
        let worktimes = worktimes.sorted(on: \.date, by: <)
        
        // start date, date of the first entry, or nil if there are no entries
        let start: Date? = startDate ?? worktimes.min(on: \.date, by: <)?.date
        // end date, date of the last entry, or NOW if there are no entries
        let end: Date? = endDate ?? worktimes.max(on: \.date, by: <)?.date
        
        // TODO: Localize
        let leftFooterText: String
        if start != nil, end != nil {
            leftFooterText = "TimeSheet Export \(start!.formatted(dateFormat)) – \(end!.formatted(dateFormat))"
        } else if end != nil {
            leftFooterText = "TimeSheet Export up to \(end!.formatted(dateFormat))"
        } else if start != nil {
            leftFooterText = "TimeSheet Export from \(start!.formatted(dateFormat))"
        } else {
            leftFooterText = "TimeSheet Export of all entries"
        }
        
        document.set(.footerLeft, font: .systemFont(ofSize: footerFontSize))
        document.add(.footerLeft, text: leftFooterText)
        document.set(.footerRight, font: .systemFont(ofSize: footerFontSize))
        document.add(.footerRight, text: "Created at \(Date.now.formatted(dateFormat))")
        
        document.set(.contentCenter, font: .systemFont(ofSize: bodyFontSize))
        // Columns:
        // Date, Activity, Hours, Wage, Total
        let table = PDFTable(rows: worktimes.count + 1, columns: 5)
        table.alignment = [[.left, .left, .left, .left, .left]] +
        Array(repeating: [.left, .left, .right, .right, .right], count: worktimes.count)
        table.padding = 4
        
        table.style.columnHeaderStyle.font = .boldSystemFont(ofSize: bodyFontSize)
        table.style.rowHeaderStyle.font = .boldSystemFont(ofSize: bodyFontSize)
        table.style.contentStyle.font = .systemFont(ofSize: bodyFontSize)
        table.style.alternatingContentStyle?.font = .systemFont(ofSize: bodyFontSize)
        
        table[row: 0].content = ["Date", "Activity", "Hours", "Wage", "Total"]
        for i in 0..<worktimes.count {
            let entry = worktimes[i]
            table[row: i + 1].content = tableRow(for: entry)
        }
        // Set proportional widths
        table.widths = [0.15, 0.45, 0.1, 0.15, 0.15]
        
        document.add(.contentCenter, table: table)
        
        
        let generator = PDFGenerator(document: document)
        return try generator.generateURL(filename: "export.pdf")
    }
    
    private func tableRow(for worktime: WorkTime) -> [PDFTableContentable] {
        // TODO: Refactor
        return [
            Self.dateFormatter.string(from: worktime.date),
            worktime.activity ?? "",
            worktime.isFixedPay ? "" :
                (Double(worktime.duration.hour ?? 0) + (Double(worktime.duration.minute ?? 0) / 60.0))
                .formatted(.number.precision(.fractionLength(2))),
            worktime.isFixedPay ? "" :
                worktime.wage
            // TODO: Replace currency code with config value
                .formatted(.currency(code: "EUR")),
            worktime.pay
            // TODO: Replace currency code with config value
                .formatted(.currency(code: "EUR")),
        ]
    }
}
