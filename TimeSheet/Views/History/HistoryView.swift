//
//  HistoryView.swift
//  TimeSheet
//
//  Created by Jonas Frey on 07.07.22.
//

import Core
import Domain
import Model
import SwiftUI

struct HistoryView: View {
    @Injected private var userData: UserData

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
