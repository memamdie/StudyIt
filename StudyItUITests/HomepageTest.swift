//
//  HomepageTest.swift
//  StudyIt
//
//  Created by Ling Nguyen on 11/18/15.
//  Copyright © 2015 Isabel Laurenceau. All rights reserved.
//

import XCTest

class HomepageTest: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        let device = XCUIDevice.sharedDevice()
        device.orientation = UIDeviceOrientation.LandscapeLeft
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHomepage() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        
        // Make sure to signout of exisiting login
        if (app.staticTexts["StudyIt"].exists == false) {
            app.navigationBars["Home"].buttons["Sign Out"].tap()
        }
        
        // Test signing in
        app.textFields["Username"].tap()
        app.textFields["Username"].typeText("test")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("test")
        app.buttons["Log In"].tap()
        
        // Homepage view
        XCTAssert(app.navigationBars["Home"].exists)
        XCTAssert(app.navigationBars["Home"].buttons["Go"].exists)
        
        app.navigationBars["Home"].buttons["Go"].tap()
        
        XCTAssert(app.navigationBars["Front"].exists)
        XCTAssert(app.navigationBars["Front"].buttons["Back of Card"].exists)
        XCTAssert(app.navigationBars["Front"].buttons["Home"].exists)
        XCTAssert(app.navigationBars["Front"].buttons["Save"].exists)
        let frontSide = app.navigationBars["Front"]

        app.navigationBars["Front"].buttons["Home"].tap()
        
        // Test log out button exist and it's function
        XCTAssert(app.navigationBars["Home"].buttons["Sign Out"].exists)
        app.navigationBars["Home"].buttons["Sign Out"].tap()
    }
    
}
