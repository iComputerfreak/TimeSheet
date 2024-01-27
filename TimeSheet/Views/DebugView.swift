//
//  DebugView.swift
//  TimeSheet
//
//  Created by Jonas Frey on 27.01.24.
//

import SwiftUI
import PDFKit

struct DebugView: View {
    @EnvironmentObject private var userData: UserData
    @State private var pdfURL: URL? = nil
    
    var body: some View {
        VStack {
            Button("Export") {
                do {
                    let worktimes = userData.worktimes
                    let pdf = try PDFExporter().export(worktimes)
//                    let url = Utils.documentsDirectoryURL().appending(component: "export.pdf")
                    self.pdfURL = pdf
                } catch {
                    print(error)
                }
            }
            
            if let pdfURL {
                ShareLink(item: pdfURL, preview: .init("Some PDF"))
            }
        }
    }
}

#Preview {
    DebugView()
}
