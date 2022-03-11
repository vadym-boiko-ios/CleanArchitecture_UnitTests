//
//  RealmStorage.swift
//  internship_app
//
//  Created by Vadym Boiko on 02.03.2022.
//

import Foundation

protocol UserProvider {
    func saveGoals(_ goals: [Goal]) -> Bool
}

protocol GoalStoreDelegate: AnyObject {
    func readyToFinish()
}

class RealmStorage {
    init() {}
}

extension RealmStorage: UserProvider {
    func saveGoals(_ goals: [Goal]) -> Bool {
        return false
    }
}

extension RealmStorage: GoalStoreDelegate {
    func readyToFinish() {
        print("I'm ready to finish")
    }
}

