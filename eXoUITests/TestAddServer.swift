//
//  TestAddServer.swift
//  eXo
//
//  Created by Nguyen Manh Toan on 12/14/15.
//  Copyright © 2015 eXo. All rights reserved.
//

import XCTest

class TestAddServer: eXoUIBaseTestCase {
  
    
    func gotoAddServerScreen () {
        let app = XCUIApplication()
        XCTAssertEqual(app.buttons.count, 4)
        app.buttons["button.new.server"].tap()
        XCTAssertEqual(app.textViews.count,1)
        XCTAssertEqual(app.tables.count,1)
    }
    
    func testAddServer() {
        self.gotoAddServerScreen()
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.textViews.containingType(.StaticText, identifier:"Enter your intranet URL").element.tap()
        tablesQuery.textViews.staticTexts["Enter your intranet URL"].tap()
        app.typeText("https://community.exoplatform.com\n")
        _ = self.expectationForPredicate(
            NSPredicate(format: "count == 1"),
            evaluatedWithObject: app.webViews,
            handler: nil)
        self.waitForExpectationsWithTimeout(100.0) { (error) -> Void in
            if error != nil {
                XCTFail("Expect webview to be shown")
            }
        }
    }
    
    func testAddServerNotSupport() {
        
        self.gotoAddServerScreen()
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.textViews.containingType(.StaticText, identifier:"Enter your intranet URL").element.tap()
        tablesQuery.textViews.staticTexts["Enter your intranet URL"].tap()
        // TODO: add a request interceptor to avoid hitting the real server, and return a predefined response
        app.typeText("https://exoplatform.exoplatform.net/\n")
        let alert = app.alerts.elementBoundByIndex(0)
        let existePredicate = NSPredicate (format: "exists == 1", argumentArray: nil)
        self.expectationForPredicate(existePredicate, evaluatedWithObject: alert, handler: nil)
        self.waitForExpectationsWithTimeout(100.0) { (error) -> Void in
            if error == nil {
                XCTAssertEqual(alert.label, "Platform version not supported")
                let okButton = alert.buttons["OK"]
                okButton.tap()
            } else {
                XCTFail("Expect alertview to be shown")
            }
        }
    }

    
    func testAddServerInvalidURL() {
        
        self.gotoAddServerScreen()
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.textViews.containingType(.StaticText, identifier:"Enter your intranet URL").element.tap()
        tablesQuery.textViews.staticTexts["Enter your intranet URL"].tap()
        app.typeText("http://invalid_server/\n")
        let alert = app.alerts.elementBoundByIndex(0)
        let existePredicate = NSPredicate (format: "exists == 1", argumentArray: nil)
        self.expectationForPredicate(existePredicate, evaluatedWithObject: alert, handler: nil)
        self.waitForExpectationsWithTimeout(100.0) { (error) -> Void in
            if error == nil {
                XCTAssertEqual(alert.label, "Intranet URL error")
                let okButton = alert.buttons["OK"]
                okButton.tap()
            } else {
                XCTFail("Expect alertview to be shown")
            }
        }
    }

}
