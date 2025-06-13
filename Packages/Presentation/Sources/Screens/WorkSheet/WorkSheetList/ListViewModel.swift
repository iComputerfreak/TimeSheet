// Copyright © 2025 Jonas Frey. All rights reserved.

import Core
import Domain
import Foundation
import JFUtils
import Model

extension ListView {
    @Observable
    public class ViewModel: ViewModelProtocol {
        var createPayoutSheetShowing = false

        var worktimes: [WorkTime] {
            get { userData.worktimes }
            set { userData.worktimes = newValue }
        }

        @ObservationIgnored
        @Injected var userData: UserData

        var years: [Int] {
            userData.worktimes
                .map(\.date.year)
                .removingDuplicates()
                .sorted(by: >)
        }

        public init() {}

        func months(in year: Int) -> [Int] {
            userData.worktimes
                .filter { worktime in
                    worktime.date.year == year
                }
                .map(\.date.month)
                .removingDuplicates()
                .sorted(by: >)
        }

        func worktimes(in year: Int, month: Int) -> [WorkTime] {
            userData.worktimes.filter { worktime in
                worktime.date.year == year && worktime.date.month == month
            }
            .sorted(on: \.date, by: >)
        }

        func didTapCreatePayout() {
            createPayoutSheetShowing = true
        }
    }
}
