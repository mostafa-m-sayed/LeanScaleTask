//
//  GamesListUITests.swift
//  LeanScaleTaskUITests
//
//  Created by Mostafa Sayed on 28/09/2021.
//

import XCTest

class GamesListUITests: XCTestCase {
    let app = XCUIApplication()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    func testSearch() {
        _ = search()
    }

    func testOpenDetails() {
        openGameDetails()
    }

    func search() -> XCUIElement {
        let tableView = app.descendants(matching: .table).firstMatch
        app.swipeDown()
        let search = app.descendants(matching: .searchField).firstMatch
        XCTAssert(search.waitForExistence(timeout: 2))
        search.tap()
        search.typeText("Fallout")
        let result = tableView.cells.containing(.staticText, identifier: "Fallout").element
        XCTAssert(result.waitForExistence(timeout: 5))
        return result
    }
    
    func openGameDetails() {
        let searchResult = search()
        searchResult.tap()
        XCTAssertTrue(app.otherElements["GameDetailsVC"].waitForExistence(timeout: 10))
    }
    
    func testFavourite() {
        openGameDetails()
        let favButton = app.navigationBars.buttons["favourite"]
        if favButton.waitForExistence(timeout: 2) && favButton.title == "favourite" {
            favButton.tap()
            checkInFavourites()
        } else {
            favButton.tap()
            checkNonInFavourites()
        }
    }
    
    func checkNonInFavourites() {
        app.tabBars.buttons.element(boundBy: 1).tap()
        let table = app.descendants(matching: .table).firstMatch
        let result = table.cells.containing(.staticText, identifier: "Fallout").element
        XCTAssert(!result.exists)
    }
    
    func checkInFavourites() {
        app.tabBars.buttons.element(boundBy: 1).tap()
        let table = app.descendants(matching: .table).firstMatch
        let result = table.cells.containing(.staticText, identifier: "Fallout").element
        XCTAssert(result.waitForExistence(timeout: 5))
    }

}
