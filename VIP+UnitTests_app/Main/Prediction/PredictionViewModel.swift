//
//  PredictionViewModel.swift
//  internship_app
//
//  Created by Vadym Boiko on 08.03.2022.
//

import Foundation
import Combine

class PredictionViewModel: ObservableObject {
    
    enum State {
        case ukraine(ViewModel)
        case shmakraine(ViewModel)
        case finished(ViewModel, String)
        
        struct ViewModel {
            let countries: [Country] = Country.countries
            let country: Country
            let switchTitle: String
            let menuTitle: String
            let menuItems: [String]
            
            init(country: Country)
            {
                self.country = country
                self.switchTitle = country.question
                self.menuTitle = country.gender
                self.menuItems = country.genderOptions
            }
        }
    }
    
    @Published var state: State
    private let store: PredictionStore
    private var cancellableBag = Set<AnyCancellable>()
    
    init(store: PredictionStore) {
        self.store = store
        let data = State.ViewModel(country: .ukraine)
        state = .ukraine(data)
        store.$state.sink { [weak self] state in
            guard let self = self else { return }
            self.state = State(state)
        }
        .store(in: &cancellableBag)
    }
    
    enum Action {
        case `continue`(selectedCountry: Country,
                        isSwitchOn: Bool,
                        selectedMenuItem: String,
                        textFieldText: String)
        case select(Country)
    }
    
    func handle(_ action: Action) {
        switch action {
        case .continue(let selectedCountry, let isSwitchOn, let selectedMenuItem, let textFieldText):
            store.handle(.continue(country: selectedCountry,
                                   textFieldText: textFieldText,
                                   selectedMenuItem: selectedMenuItem,
                                   isSwitchOn: isSwitchOn))
        case .select(let country):
            store.handle(.select(country))
        }
    }
}

extension PredictionViewModel.State {
    
    init(_ state: PredictionStore.State) {
        switch state {
        case .ukraine(let country):
            let viewModel = ViewModel(country: country)
            self = .ukraine(viewModel)
        case .shmakraine(let country):
            let viewModel = ViewModel(country: country)
            self = .shmakraine(viewModel)
        case .finished(let country, let prediction):
            let viewModel = ViewModel(country: country)
            self = .finished(viewModel, prediction)
        case .failure(let country, let error):
            let viewModel = ViewModel(country: country)
            self = .finished(viewModel, error.localizedDescription)
        }
    }
    
    var viewModel: ViewModel {
        switch self {
        case .ukraine(let viewModel):
            return viewModel
        case .shmakraine(let viewModel):
            return viewModel
        case .finished(let viewModel, _):
            return viewModel
        }
    }
}
