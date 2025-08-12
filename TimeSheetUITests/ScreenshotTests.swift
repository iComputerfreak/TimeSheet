//
//  TimeSheetUITests.swift
//  TimeSheetUITests
//
//  Created by Jonas Frey on 03.01.23.
//

import XCTest

@MainActor
final class ScreenshotTests: XCTestCase {
    private var app = XCUIApplication()
    private var screenshotCounter: Int = 1

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
    }

    @MainActor
    func testTakeAppStoreScreenshots() throws {
        setupSnapshot(app)

        app.launch()

        // MARK: Set up sample data
        // If we have some data present, create a payout to make the debug button in settings visible
        if app.cells.count > 0 {
            app.navigationBars.buttons["payout-button"].tap()
            app.navigationBars.buttons["create-button"].tap()
        }
        // Create the sample data
        app.buttons["settings-tab"].firstMatch.tap()
        app.buttons["Generate"].firstMatch.tap()
        app.buttons["sheet-tab"].firstMatch.tap()

        // Take the screenshots
        snapshot("Sheet")

        app.navigationBars.buttons["add"].forceTap()
        app.buttons["time-based"].firstMatch.tap()
        snapshot("Create_Entry_Time")
        app.navigationBars.buttons.firstMatch.tap()

        app.navigationBars.buttons["payout-button"].tap()
        snapshot("Create_Payout")
        app.swipeDown(velocity: .fast)

        app.buttons["payouts-tab"].firstMatch.tap()
        snapshot("Payouts")

        app.buttons["history-tab"].firstMatch.tap()
        snapshot("History")

        app.buttons["settings-tab"].firstMatch.tap()
        snapshot("Settings")
    }

    @MainActor
    private func snapshot(_ name: String) {
        Snapshot.snapshot("\(String(format: "%02d", screenshotCounter))_\(name)")
        screenshotCounter += 1
    }
}

extension XCUIElement {
    func forceTap() {
        coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
    }
}
