//
//  TimeSheetUITests.swift
//  TimeSheetUITests
//
//  Created by Jonas Frey on 03.01.23.
//

import XCTest

final class TimeSheetUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        
    }

    func testTakeAppStoreScreenshots() throws {
        let app = XCUIApplication()
        app.launch()

        // Set up sample data
        app.navigationBars.firstMatch.buttons["Payout"].tap()
        app.navigationBars.firstMatch.buttons["Create"].tap()
        app.tabBars.buttons["Settings"].tap()
        app.buttons["Generate Screenshot Data"].tap()
        app.tabBars.buttons["Sheet"].tap()
        
        // Take the screenshots
        
    }
}
