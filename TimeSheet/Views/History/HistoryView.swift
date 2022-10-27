//
//  HistoryView.swift
//  TimeSheet
//
//  Created by Jonas Frey on 07.07.22.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject private var userData: UserData
    
    var worktimes: [WorkTime] {
        userData.worktimes + userData.payouts.flatMap(\.worktimes)
    }
    
    var body: some View {
        ChartsView(worktimes: worktimes)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
