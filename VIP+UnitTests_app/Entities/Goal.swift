//
//  Goal.swift
//  internship_app
//
//  Created by Vadym Boiko on 02.03.2022.
//

enum Goal: String, CaseIterable {
    case nowar = "No war"
    case moregirls = "More girls"
    case morefriends = "More friends"
}

extension Goal {
    static var goals: [Goal] = Goal.allCases
}
