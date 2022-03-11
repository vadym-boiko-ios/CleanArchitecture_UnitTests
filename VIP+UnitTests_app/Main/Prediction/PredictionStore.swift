//
//  PredictionStore.swift
//  internship_app
//
//  Created by Vadym Boiko on 08.03.2022.
//

import Foundation
import Combine

class PredictionStore {
    
    enum State {
        case ukraine(Country)
        case shmakraine(Country)
        case failure(Country, Error)
        case finished(Country, String)
    }
    
    @Published var state: State
    let validationProvider: Validation
    let networkProvider: Network
    
    init(validationProvider: Validation, networkProvider: Network) {
        self.validationProvider = validationProvider
        self.networkProvider = networkProvider
        state = .ukraine(.ukraine)
    }
    
    enum Action {
        case select(Country)
        case `continue`(country: Country, textFieldText: String, selectedMenuItem: String, isSwitchOn: Bool)
    }
    
    func handle(_ action: Action) {
        switch action {
        case .select(let country):
            switch country {
            case .ukraine:
                state = .ukraine(.ukraine)
            case .shmakraine:
                state = .shmakraine(.shmakraine)
            }
        case .continue(let country, let textFieldText, let selectedMenuItem, let isSwitchOn):
            guard isSwitchOn else { return }
            guard !selectedMenuItem.isEmpty && country.genderOptions.contains(selectedMenuItem) else { return }
            guard validationProvider.isValidEmail(textFieldText) else { return }
            
            networkProvider.request { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    let finishedString = "\(country.rawValue) choose \(selectedMenuItem) but our request always scream \(data)"
                    self.state = .finished(self.state.country, finishedString)
                    print(self.state)
                case .failure(let error):
                    self.state = .failure(self.state.country, error)
                }
            }
        }
    }
}

extension PredictionStore.State: Equatable {
    var country: Country {
        switch self {
        case .ukraine(let country):
            return country
        case .shmakraine(let country):
            return country
        case .failure(let country, _):
            return country
        case .finished(let country, _):
            return country
        }
    }
    
    var finishedStatePhrase: String {
        switch self {
        case .ukraine(_):
            return ""
        case .shmakraine(_):
            return ""
        case .failure(_, _):
            return ""
        case .finished(_, let string):
            return string
        }
    }
    
    static func == (lhs: PredictionStore.State, rhs: PredictionStore.State) -> Bool {
        lhs.country == rhs.country && lhs.finishedStatePhrase == rhs.finishedStatePhrase
    }
}

enum NetworkError: String, Error, Equatable {
    case failure = "Failed network request"
}
