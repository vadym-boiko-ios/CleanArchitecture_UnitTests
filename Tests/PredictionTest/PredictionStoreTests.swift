//
//  PredictionStoreTests.swift
//  Tests
//
//  Created by Vadym Boiko on 10.03.2022.
//

import XCTest
@testable import VIP_UnitTests_app

class PredictionStoreTests: XCTestCase {
    var sut: PredictionStore!
    var validationMock: ValidationMock!
    var networkMock: NetworkMock!
    
    override func setUpWithError() throws {
        validationMock = .init()
        networkMock = .init()
        sut = PredictionStore(validationProvider: validationMock, networkProvider: networkMock)
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testInitialState() {
        let expectedState = PredictionStore.State.ukraine(.ukraine)
        
        XCTAssertEqual(sut.state, expectedState)
    }
    
    func testHandleSelectCountry() {
        let expectedStateWithShmakraine = PredictionStore.State.shmakraine(.shmakraine)
        sut.handle(.select(.shmakraine))
        XCTAssertEqual(sut.state, expectedStateWithShmakraine)
        
        let expectedStateWithUkraine = PredictionStore.State.ukraine(.ukraine)
        sut.handle(.select(.ukraine))
        XCTAssertEqual(sut.state, expectedStateWithUkraine)
    }
    
    func testHandleContinueWithSwitchOff() {
        let expectedState = PredictionStore.State.ukraine(.ukraine)
        
        sut.handle(.continue(country: .ukraine, textFieldText: "vadym.boiko@gmail.com", selectedMenuItem: "Male", isSwitchOn: false))
        
        XCTAssertEqual(sut.state, expectedState)
        XCTAssertEqual(validationMock.isValidEmailCalledCount, 0)
        XCTAssertEqual(networkMock.requestCalledCount, 0)
    }
    
    func testHandleContinueWithEmptySelectedMenuItem() {
        let expectedState = PredictionStore.State.ukraine(.ukraine)
        sut.handle(.continue(country: .ukraine, textFieldText: "vadym.boiko@gmail.com", selectedMenuItem: "", isSwitchOn: true))
        
        XCTAssertEqual(sut.state, expectedState)
        XCTAssertEqual(validationMock.isValidEmailCalledCount, 0)
        XCTAssertEqual(networkMock.requestCalledCount, 0)
    }
    
    func testHandleContinueWithSelectedMenuItemFromAnotherCounty() {
        
    }
    
    func testHandleContinueWithEmailValidationAndReturnFalseValue() {
        let expectedState = PredictionStore.State.ukraine(.ukraine)
        validationMock.isValidEmailReturnValue = false
        
        sut.handle(.continue(country: .ukraine, textFieldText: "vadym.boiko@gmail", selectedMenuItem: "Male", isSwitchOn: true))
        
        XCTAssertEqual(sut.state, expectedState)
        XCTAssertEqual(validationMock.isValidEmailCalledCount, 1)
        XCTAssertEqual(networkMock.requestCalledCount, 0)
        
    }
    
    func testHandleContinueWithNetworkRequestAndReturnFailure() {
        let expectedState = PredictionStore.State.failure(.ukraine, NetworkError.failure)
        validationMock.isValidEmailReturnValue = true
        networkMock.requestCallReturnValue = .failure(NetworkError.failure)
        
        sut.handle(.continue(country: .ukraine, textFieldText: "vadym.boiko@gmail.com", selectedMenuItem: "Male", isSwitchOn: true))
        
        XCTAssertEqual(sut.state, expectedState)
        XCTAssertEqual(validationMock.isValidEmailCalledCount, 1)
        XCTAssertEqual(networkMock.requestCalledCount, 1)
    }
    
    func testHandleContinueWithNetworkRequestAndReturnSuccess() {
        let expectedState = PredictionStore.State.finished(.ukraine, "Ukraine choose Male but our request always scream Always write tests")
        validationMock.isValidEmailReturnValue = true
        networkMock.requestCallReturnValue = .success("Always write tests")
        
        sut.handle(.continue(country: .ukraine, textFieldText: "vadym.boiko@gmail.com", selectedMenuItem: "Male", isSwitchOn: true))
        
        XCTAssertEqual(sut.state, expectedState)
        XCTAssertEqual(validationMock.isValidEmailCalledCount, 1)
        XCTAssertEqual(networkMock.requestCalledCount, 1)
    }
    
    func testHandleSelectAndContinueWithNetworkRequestAndReturnSuccess() {
        let expectedState = PredictionStore.State.finished(.shmakraine, "Shmakraine choose Shmale but our request always scream Always write tests")
        validationMock.isValidEmailReturnValue = true
        networkMock.requestCallReturnValue = .success("Always write tests")
        sut.handle(.select(.shmakraine))
        
        sut.handle(.continue(country: .shmakraine, textFieldText: "vadym.boiko@gmail.com", selectedMenuItem: "Shmale", isSwitchOn: true))
        
        XCTAssertEqual(sut.state, expectedState)
        XCTAssertEqual(validationMock.isValidEmailCalledCount, 1)
        XCTAssertEqual(networkMock.requestCalledCount, 1)
        
        let currentState = sut.state
        
        sut.handle(.continue(country: .shmakraine, textFieldText: "vadym.boiko@gmail.com", selectedMenuItem: "Shmale", isSwitchOn: true))
        
        XCTAssertEqual(sut.state, currentState)
        XCTAssertEqual(validationMock.isValidEmailCalledCount, 2)
        XCTAssertEqual(networkMock.requestCalledCount, 2)
    }
}

