//
//  TimeSheetUITests.swift
//  TimeSheetUITests
//
//  Created by Jonas Frey on 03.01.23.
//

import XCTest

final class TimeSheetUITests: XCTestCase {
    
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        setupSnapshot(app)
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
        Snapshot.snapshot("01_Sheet")
        
        app.navigationBars.buttons["payout-button"].tap()
        Snapshot.snapshot("02_Create_Payout")
        app.swipeDown(velocity: .fast)
        
        app.tabBars.buttons["payouts-tab"].tap()
        Snapshot.snapshot("03_Payouts")
        
        app.tabBars.buttons["history-tab"].tap()
        Snapshot.snapshot("04_History")
        
        app.tabBars.buttons["settings-tab"].tap()
        Snapshot.snapshot("05_Settings")
    }
}
