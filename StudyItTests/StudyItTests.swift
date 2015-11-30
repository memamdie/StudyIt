//
//  StudyItTests.swift
//  StudyItTests
//
//  Created by Ling Nguyen on 11/9/15.
//  Copyright © 2015 Isabel Laurenceau. All rights reserved.
//

import XCTest
import StudyIt
import UIKit

class StudyItTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testViewLoadForController() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let vc = ViewController()
        XCTAssertNotNil(vc.view, "View did not load for ViewController")
        
        let cvc = CardViewController()
        XCTAssertNotNil(cvc.view, "View did not load for CardViewController")
        
        /*let fvc = FrontViewController()
        XCTAssertNotNil(fvc.view, "View did not load for FrontViewController")
        
        let bvc = BackViewController()
        XCTAssertNotNil(bvc.view, "View did not load for BackViewController")*/
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
