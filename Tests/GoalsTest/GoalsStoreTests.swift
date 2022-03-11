//
//  GoalsStoreTests.swift
//  Tests
//
//  Created by Vadym Boiko on 03.03.2022.
//

import XCTest
@testable import VIP_UnitTests_app

class GoalsStoreTests: XCTestCase {
    var sut: GoalsStore!
    var userProviderMock: UserProviderMock!
    var delegateSpy: GoalStoreDelegateSpy!

    override func setUpWithError() throws {
        userProviderMock = .init()
        sut = GoalsStore(userProvider: userProviderMock)
        delegateSpy = GoalStoreDelegateSpy()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testInitialState() {
        let expectedState = GoalsStore.State.data(data: GoalsStoreTests.deselectedAllGoals)
        XCTAssertEqual(sut.state, expectedState)
    }

    func testHandleSelectByIndex() {
        (0...2).forEach { index in
            sut.handle(.select(index))
            let selectedFistTimeGoals = sut.state.goals[index].isSelected
            XCTAssertEqual(selectedFistTimeGoals, true)

            sut.handle(.select(index))
            let selectedSecondTimeGoals = sut.state.goals[index].isSelected
            XCTAssertEqual(selectedSecondTimeGoals, false)
        }
    }
    
    func testHandleSelectAllAndDeselectAll() {
        let selectedAllState = GoalsStore.State.data(data: GoalsStoreTests.selectedAllGoals)
        let deselectedAllState = GoalsStore.State.data(data: GoalsStoreTests.deselectedAllGoals)
        
        sut.handle(.selectAll)
        XCTAssertEqual(sut.state, selectedAllState)
        
        sut.handle(.selectAll)
        XCTAssertEqual(sut.state, deselectedAllState)
        
        sut.handle(.selectAll)
        XCTAssertEqual(sut.state, selectedAllState)
    }
        
    func testHandleDoneWithReturnTrueValue() {
        
        let expectedFinishedState = GoalsStore.State.finished(data: GoalsStoreTests.withOneSelectedGoals)
        let expectedPassedGoals: [Goal] = [.nowar]
     
        userProviderMock.savedGoalsReturnValue = true
        sut.delegate = delegateSpy
        sut.handle(.select(0))
        
        sut.handle(.done)
        
        XCTAssertEqual(sut.state, expectedFinishedState)
        XCTAssertEqual(userProviderMock.savedGoalsCalledCount, 1)
        XCTAssertEqual(userProviderMock.passedGoals, expectedPassedGoals)
        XCTAssertEqual(delegateSpy.delegateCalledCount, 1)
    }
    
    func testHandleDoneWithReturnFalseValue() {
        let expectedDoneState = GoalsStore.State.data(data: GoalsStoreTests.deselectedAllGoals)
        
        userProviderMock.savedGoalsReturnValue = false
        sut.handle(.done)
        
        XCTAssertEqual(sut.state, expectedDoneState)
        XCTAssertEqual(userProviderMock.savedGoalsCalledCount, 1)
        XCTAssertEqual(delegateSpy.delegateCalledCount, 0)
    }
}

extension GoalsStoreTests {
    static let deselectedAllGoals: [GoalsStore.State.Data] = [.init(goal: .nowar, isSelected: false),
                                                 .init(goal: .moregirls, isSelected: false),
                                                 .init(goal: .morefriends, isSelected: false)]
    
    static let selectedAllGoals: [GoalsStore.State.Data] = [.init(goal: .nowar, isSelected: true),
                                                                      .init(goal: .moregirls, isSelected: true),
                                                                      .init(goal: .morefriends, isSelected: true)]
    static let withOneSelectedGoals: [GoalsStore.State.Data] = [.init(goal: .nowar, isSelected: true),
                                                                .init(goal: .moregirls, isSelected: false),
                                                                .init(goal: .morefriends, isSelected: false)]
}
