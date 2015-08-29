//
//  ClientTests.swift
//  WolframAlphaTests
//
//  Created by Roman Roibu on 8/29/15.
//  Copyright © 2015 Roman Roibu. All rights reserved.
//

import XCTest
@testable import WolframAlpha

class ClientTests: XCTestCase {
    var client: WolframAlpha!

    var appID: String {
        return NSProcessInfo.processInfo().environment["WOLFRAM_APP_ID"]!
    }

    override func setUp() {
        super.setUp()
        self.client = WolframAlpha(appID: appID)
    }

    override func tearDown() {
        self.client = nil
        super.tearDown()
    }

    func testClientDataResponse() {
        let expectation = self.expectationWithDescription("Client should return NSData result")
        self.client.queryData("pi") { result in
            switch result {
            case .Success(let data):
                XCTAssert(data.length > 0, "Result Data is empty")
            case .Failure(let error):
                XCTAssert(false, "Result Error: \(error)")
            }
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(10.0, handler: nil)
    }

    func testClientXMLResponse() {
        let expectation = self.expectationWithDescription("Client should return NSData result")
        self.client.queryXML("pi") { result in
            switch result {
            case .Success(let xml):
                XCTAssert(xml["success"] == "true", "Result XML is a success")
                XCTAssert(xml["error"] == "false",  "Result XML is not an error")
                XCTAssert(xml.children.count > 0, "Result XML doesn't have any children")
            case .Failure(let error):
                XCTAssert(false, "Result Error: \(error)")
            }
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(10.0, handler: nil)
    }
}

