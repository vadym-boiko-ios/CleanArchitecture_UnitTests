//
//  GoalStoreDelegateSpy.swift
//  Tests
//
//  Created by Vadym Boiko on 07.03.2022.
//
@testable import VIP_UnitTests_app

class GoalStoreDelegateSpy: GoalStoreDelegate {
    var delegateCalledCount = 0
    
    func readyToFinish() {
      delegateCalledCount += 1
    }
}
