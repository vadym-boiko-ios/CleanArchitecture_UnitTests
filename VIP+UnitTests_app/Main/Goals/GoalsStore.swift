//
//  GoalsStore.swift
//  internship_app
//
//  Created by Vadym Boiko on 02.03.2022.
//

import Combine
import Foundation

class GoalsStore {
    weak var delegate: GoalStoreDelegate?
    
    enum State {
        case data(data: [Data])
        case finished(data: [Data])
        
        struct Data: Equatable {
            let goal: Goal
            var isSelected: Bool
        }
    }
    
    @Published var state: State
    let userProvider: UserProvider

    init(userProvider: UserProvider = RealmStorage()) {
        self.userProvider = userProvider
        let data = Goal.goals.map { State.Data(goal: $0,
                                               isSelected: false)}
        state = .data(data: data)
    }
    
    enum Action {
        case select(_ index: Int)
        case selectAll
        case done
    }
    
    func handle(_ action: Action) {
        switch action {
        case .select(let index):
            var selectedGoals = state.goals
            selectedGoals[index].isSelected.toggle()
            state = .data(data: selectedGoals)
        case .selectAll:
            if state.goals.contains(where: { $0.isSelected == true}) {
                let deselectedAll = state.goals.map { State.Data(goal: $0.goal,
                                                        isSelected: false) }
                state = .data(data: deselectedAll)
            } else {
                let selectedAll = state.goals.map { State.Data(goal: $0.goal,
                                                        isSelected: true) }
                state = .data(data: selectedAll)
            }
        case .done:
            let data = state.goals.filter { $0.isSelected == true }
                                  .map { $0.goal }
            if userProvider.saveGoals(data) {
                state = .finished(data: state.goals)
                delegate?.readyToFinish()
            }
        }
    }
}

extension GoalsStore.State {
    var goals: [Data] {
        switch self {
        case .data(let data):
            return data
        case .finished(let data):
            return data
        }
    }
}

extension GoalsStore.State: Equatable {
    static func == (lhs: GoalsStore.State, rhs: GoalsStore.State) -> Bool {
        lhs.goals == rhs.goals
    }
}


