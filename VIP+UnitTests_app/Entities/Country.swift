//
//  Country.swift
//  internship_app
//
//  Created by Vadym Boiko on 09.03.2022.
//

import Foundation

enum Country: String, CaseIterable {
    case ukraine = "Ukraine"
    case shmakraine = "Shmakraine"
    
    var question: String {
        switch self {
        case .ukraine:
            return "Are you ukrainian?"
        case .shmakraine:
            return "Are you shmakrainian?"
        }
    }
    
    var gender: String {
        switch self {
        case .ukraine:
            return "Gender?"
        case .shmakraine:
            return "Shmender?"
        }
    }
    
    var genderOptions: [String] {
        switch self {
        case .ukraine:
            return ["Female", "Male"]
        case .shmakraine:
            return ["Shfemale", "Shmale"]
        }
    }
    
    static var countries = Self.allCases
}
