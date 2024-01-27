//
//  PDFExporter.swift
//  TimeSheet
//
//  Created by Jonas Frey on 27.01.24.
//

import Foundation
import PDFKit

class PDFExporter: ExporterProtocol {
    let pdfFormat: UIGraphicsPDFRendererFormat = {
        let pdfMetaData = [
            kCGPDFContextCreator: "TimeSheet for iOS",
            kCGPDFContextAuthor: "jonasfrey.de"
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        return format
    }()
    
    func export(_ worktimes: [WorkTime]) -> PDFDocument? {
        // DIN A4 @ 72 DPI
        let pageWidth = 8.2677165354 * 72.0
        let pageHeight = 11.6929133858 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: pdfFormat)
        let data = renderer.pdfData { (context) in
            render(worktimes, in: context)
        }
        
        return PDFDocument(data: data)
    }
    
    private func render(_ worktimes: [WorkTime], in context: UIGraphicsPDFRendererContext) {
        context.beginPage()
        let largeTitleAttributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 36)
        ]
        let bodyAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
        ]
        let text = "I'm a PDF!"
        text.draw(at: CGPoint(x: 0, y: 0), withAttributes: largeTitleAttributes)
    }

}
