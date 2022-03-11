//
//  ValidationTests.swift
//  Tests
//
//  Created by Vadym Boiko on 11.03.2022.
//

import XCTest
@testable import VIP_UnitTests_app

class ValidationTests: XCTestCase {
    var sut: ValidationService!
    
    override func setUpWithError() throws {
        sut = ValidationService()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testEmptyEmail() {
        let emptyEmail = ""
        XCTAssertFalse(sut.isValidEmail(emptyEmail))
    }
    
    func testProperEmail() {
        let properEmail = "v@gmail.com"
        XCTAssertTrue(sut.isValidEmail(properEmail))
    }
    
    func testEmailWithMistakes() {
        let emailWithoutAtSign = "vgmail.com"
        XCTAssertFalse(sut.isValidEmail(emailWithoutAtSign))
        
        let emailWithoutDot = "v@gmailcom"
        XCTAssertFalse(sut.isValidEmail(emailWithoutDot))
        
        let emailWithoutWordAfterDot = "v@gmail."
        XCTAssertFalse(sut.isValidEmail(emailWithoutWordAfterDot))
    }
}
