//
//  IntExtensions.swift
//  DailyFXDemoTests
//
//  Created by Nitesh Patel on 06/05/2022.
//

import XCTest

class IntExtensionsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_TimeInterval_Into_Display_Date_Example() throws {
        //    1620317006000
        //    Actual Date - GMT: Thursday, May 6, 2021 4:03:26 PM
        // expected Display formatted: MMM dd, yyyy at HH:mm:ss AM/PM
    
        var intTimeinterval = 1620317006000
        XCTAssertEqual(intTimeinterval.convertToDisplayDate(), "May 6, 2021 at 5:03:26 PM")
        
        // change time Interval just one digit
        intTimeinterval = 1620317005000
        XCTAssertNotEqual(intTimeinterval.convertToDisplayDate(), "May 6, 2021 at 5:03:26 PM")
        XCTAssertEqual(intTimeinterval.convertToDisplayDate(), "May 6, 2021 at 5:03:25 PM")
    }
    
    func test_TimeInterval_Into_Date() throws {
        //    1620317006000
        //    Actual Date - GMT: Thursday, May 6, 2021 4:03:26 PM
        let intTimeinterval = 1620317006000
        
        var expectedTimeInterval: TimeInterval = 1620317006
        var expectedDate = Date(timeIntervalSince1970: expectedTimeInterval)
        // Date Should not match
        XCTAssertEqual(intTimeinterval.fromUnixTimeStamp(), expectedDate)
        
        // change time Interval just one digit
        expectedTimeInterval = 1620317005
        expectedDate = Date(timeIntervalSince1970: expectedTimeInterval)
        // Date Should not match
        XCTAssertNotEqual(intTimeinterval.fromUnixTimeStamp(), expectedDate)
    }
}
