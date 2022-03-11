//
//  RealmStorageMock.swift
//  Tests
//
//  Created by Vadym Boiko on 03.03.2022.
//

import Foundation
@testable import VIP_UnitTests_app

class UserProviderMock: UserProvider {
    var passedGoals: [Goal]!
    var savedGoalsCalledCount = 0
    var savedGoalsReturnValue: Bool!
    
    func saveGoals(_ goals: [Goal]) -> Bool {
        passedGoals = goals
        savedGoalsCalledCount += 1
        return savedGoalsReturnValue
    }
}

