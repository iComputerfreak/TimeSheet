// Copyright © 2025 Jonas Frey. All rights reserved.

@testable import Presentation

import Core
import Domain
import Testing

@MainActor
@Suite(.tags(.unit))
struct SettingsViewModelTests {
    private let sut = SettingsView.ViewModel()

    @Injected private var userData: UserData

    init() {
        registerTestingDependencies()
    }

    @Test
    func testGenerateSampleData() async {
        #expect(sut.userData.worktimes.isEmpty)
        sut.generateSampleData()
        #expect(sut.userData.worktimes == SampleData.screenshotWorktimes)
    }
}
