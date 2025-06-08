//
//  SettingsView.swift
//  TimeSheet
//
//  Created by Jonas Frey on 09.06.22.
//

import Core
import Domain
import Model
import SwiftUI

public struct SettingsView: StatefulView {
    @State public var viewModel: ViewModel

    // swiftlint:disable:next type_contents_order
    public init(viewModel: ViewModel = .init()) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationStack {
            Form {
                WageStepper(wage: $viewModel.wage)
                Picker(Strings.Settings.currency, selection: $viewModel.currency) {
                    ForEach(Locale.commonISOCurrencyCodes, id: \.self) { code in
                        Text(code)
                    }
                }
                #if DEBUG
                if viewModel.userData.worktimes.isEmpty {
                    Button(Strings.List.NavigationBar.generate) {
                        viewModel.userData.worktimes = SampleData.screenshotWorktimes
                        viewModel.userData.payouts = SampleData.screenshotPayouts
                    }
                }
                #endif
            }
            .navigationTitle(Strings.Settings.navigationTitle)
        }
    }
}

#if DEBUG
#Preview {
    SettingsView()
        .previewEnvironment()
}
#endif
