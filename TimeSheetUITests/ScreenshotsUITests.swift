//
//  TimeSheetUITests.swift
//  TimeSheetUITests
//
//  Created by Jonas Frey on 03.01.23.
//

import XCTest

final class TimeSheetUITests: XCTestCase {
    
    private var app: XCUIApplication!
    private var screenshotCounter: Int!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        setupSnapshot(app)
        screenshotCounter = 1
    }

    func testTakeAppStoreScreenshots() throws {
        app.launch()

        // MARK: Set up sample data
        // If we have some data present, create a payout to make the debug button in settings visible
        if app.cells.count > 0 {
            app.navigationBars.buttons["payout-button"].tap()
            app.navigationBars.buttons["create-button"].tap()
        }
        // Create the sample data
        app.tabBars.buttons["settings-tab"].tap()
        app.buttons["Generate Screenshot Data"].tap()
        app.tabBars.buttons["sheet-tab"].tap()
        
        // Take the screenshots
        snapshot("Sheet")
        
        app.navigationBars.buttons["add"].tap()
        app.buttons["time-based"].tap()
        snapshot("Create_Entry_Time")
        app.navigationBars.buttons.firstMatch.tap()
        
        app.navigationBars.buttons["payout-button"].tap()
        snapshot("Create_Payout")
        app.swipeDown(velocity: .fast)
        
        app.tabBars.buttons["payouts-tab"].tap()
        snapshot("Payouts")
        
        app.tabBars.buttons["history-tab"].tap()
        snapshot("History")
        
        app.tabBars.buttons["settings-tab"].tap()
        snapshot("Settings")
    }
    
    // Take a snapshot with a global increasing counter as a prefix
    private func snapshot(_ name: String) {
        Snapshot.snapshot("\(String(format: "%02d", screenshotCounter))_\(name)")
        screenshotCounter += 1
    }
}
