// Copyright © 2025 Jonas Frey. All rights reserved.

@testable import Presentation

import Core
import Domain
import Foundation
import Model
import SwiftUI
import Testing

@MainActor
@Suite(.tags(.unit))
struct ListViewTests {
    @Injected private var userData: UserData

    init() {
        setupTesting()
    }

    @Test func testWorkTimes() async {
        userData.worktimes = SampleData.screenshotWorktimes

        let sut: ListView.ViewModel = .init()

        #expect(sut.years == [2023, 2022])
        #expect(sut.months(in: 2023) == [1])
        #expect(sut.months(in: 2022) == [12, 11])
        #expect(sut.worktimes == userData.worktimes)
        #expect(
            sut.worktimes(in: 2023, month: 1) == [SampleData.screenshotWorktimes[5]]
        )
        #expect(
            sut.worktimes(in: 2022, month: 12) == [4, 3].map { SampleData.screenshotWorktimes[$0] }
        )
        #expect(
            sut.worktimes(in: 2022, month: 11) == [2, 1, 0].map { SampleData.screenshotWorktimes[$0] }
        )
    }

    @Test func testDidTapCreatePayout() {
        let sut: ListView.ViewModel = .init()
        #expect(sut.createPayoutSheetShowing == false)

        sut.didTapCreatePayout()

        #expect(sut.createPayoutSheetShowing == true)
    }
}
