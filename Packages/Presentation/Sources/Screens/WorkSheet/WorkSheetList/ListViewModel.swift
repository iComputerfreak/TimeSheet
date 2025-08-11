// Copyright © 2025 Jonas Frey. All rights reserved.

import Core
import Domain
import Foundation
import JFUtils
import Model
import SwiftUI

extension ListView {
    @Observable
    public class ViewModel: ViewModelProtocol {
        var createPayoutSheetShowing = false

        var userData: UserData {
            DependencyContext.current.resolve()
        }

        var worktimesBinding: Binding<[WorkTime]> {
            Binding {
                self.userData.worktimes
            } set: { newValue in
                self.userData.worktimes = newValue
            }
        }

        public init() {}

        func didTapCreatePayout() {
            createPayoutSheetShowing = true
        }
    }
}
