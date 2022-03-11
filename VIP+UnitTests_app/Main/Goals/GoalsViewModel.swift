//
//  GoalsViewModel.swift
//  internship_app
//
//  Created by Vadym Boiko on 02.03.2022.
//

import Combine
import Foundation

class GoalsViewModel: ObservableObject {
    
    enum State {
        case data(viewModels: [ViewModel])
        case finished
        
        struct ViewModel: Equatable, Identifiable {
            let id = UUID()
            let title: String
            let isSelected: Bool
        }
    }
    
    private let store: GoalsStore
    private var cancellableBag = Set<AnyCancellable>()
    @Published var state: State
    
    init(store: GoalsStore) {
        self.store = store
        let data = Goal.goals.map { State.ViewModel(title: $0.rawValue,
                                                    isSelected: false)}
        state = .data(viewModels: data)
        
        store.$state.sink { [weak self] state in
            guard let self = self else { return }
            self.state = State(state)
        }
        .store(in: &cancellableBag)
    }
    
    enum Action {
        case select(_ index: Int)
        case selectAll
        case done
    }
    
    func handle(_ action: Action) {
        switch action {
        case .select(let index):
            store.handle(.select(index))
        case .selectAll:
            store.handle(.selectAll)
        case .done:
            store.handle(.done)
        }
    }
}

extension GoalsViewModel.State {
    init(_ state: GoalsStore.State) {
        let data = state.goals.map { GoalsViewModel.State.ViewModel(title: $0.goal.rawValue,
                                                                    isSelected: $0.isSelected)}
        self = .data(viewModels: data)
    }
    
    var viewModels: [ViewModel] {
        switch self {
        case .data(let viewModels):
            return viewModels
        case .finished:
            return []
        }
    }
}
