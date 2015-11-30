//
//  StudyItUITests.swift
//  StudyItUITests
//
//  Created by Ling Nguyen on 11/9/15.
//  Copyright © 2015 Isabel Laurenceau. All rights reserved.
//

import XCTest

class StudyItUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoginViewWithExistingAccount() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        
        // Make sure to signout of exisiting login
        if (app.staticTexts["StudyIt"].exists == false) {
            app.navigationBars["Profile"].buttons["Sign Out"].tap()
        }
        
        // Testing text fields on login view and their behaviors
        XCTAssert(app.staticTexts["StudyIt"].exists)
        XCTAssert(app.textFields["Username"].exists)
        XCTAssert(app.secureTextFields["Password"].exists)
        XCTAssert(app.buttons["Log In"].exists)
        XCTAssert(app.buttons["Forgot Password?"].exists)
        app.buttons["Forgot Password?"].tap()
        
        XCTAssert(app.staticTexts["Reset Password"].exists)
        XCTAssert(app.buttons["Cancel"].exists)
        XCTAssert(app.buttons["OK"].exists)
        XCTAssert(app.textFields["Email"].exists)
        
        app.buttons["Cancel"].tap()
        
        // Test signing in with existing account
        app.textFields["Username"].tap()
        app.textFields["Username"].typeText("test")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("test")
        app.buttons["Log In"].tap()

        // Test log out button's function
        app.navigationBars["Profile"].buttons["Sign Out"].tap()
    }
    
    func testLoginViewWithInvalidAccount() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        
        // Make sure to signout of exisiting login
        if (app.staticTexts["StudyIt"].exists == false) {
            app.navigationBars["Prfile"].buttons["Sign Out"].tap()
        }
        
        // Test signing in with existing account
        app.textFields["Username"].tap()
        app.textFields["Username"].typeText("Invalid")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("Invalid")
        app.buttons["Log In"].tap()
        
        // check user stay in login view for invalid login
        XCTAssert(app.staticTexts["StudyIt"].exists)
    }
}
