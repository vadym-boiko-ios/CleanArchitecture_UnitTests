//
//  Validation.swift
//  internship_app
//
//  Created by Vadym Boiko on 09.03.2022.
//

import Foundation

protocol Validation {
    func isValidEmail(_ email: String) -> Bool
}

class ValidationService {
    init() {}
}

extension ValidationService: Validation {
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
