//
//  ValidationMock.swift
//  Tests
//
//  Created by Vadym Boiko on 10.03.2022.
//

import Foundation
@testable import VIP_UnitTests_app

class ValidationMock: Validation {
    var passedEmail: String!
    var isValidEmailCalledCount = 0
    var isValidEmailReturnValue: Bool!
    
    func isValidEmail(_ email: String) -> Bool {
        passedEmail = email
        isValidEmailCalledCount += 1
        return isValidEmailReturnValue
    }
}
