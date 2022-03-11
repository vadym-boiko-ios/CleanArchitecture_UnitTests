//
//  PrectionView.swift
//  internship_app
//
//  Created by Vadym Boiko on 08.03.2022.
//

import SwiftUI

struct PredictionView: View {
    @ObservedObject var viewModel: PredictionViewModel
    
    @State private var selectedCountry: Country
    @State private var isOn: Bool = false
    @State private var selectedMenuItem: String = ""
    @State private var textFieldText: String = ""
    @State private var isEnabled: Bool = false
    
    
    init(viewModel: PredictionViewModel) {
        self.viewModel = viewModel
        self.selectedCountry = viewModel.state.viewModel.country
    }
    
    var body: some View {
        VStack {
            Picker("", selection: $selectedCountry) {
                ForEach(viewModel.state.viewModel.countries, id: \.self) { country in
                    Text(country.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .onTapGesture {
                //.onTapGesture runs when the picker is tapped, but the picker itself is not responding to taps.
                switch selectedCountry {
                case .ukraine:
                    selectedCountry = .ukraine
                case .shmakraine:
                    selectedCountry = .shmakraine
                }
                
                viewModel.handle(.select(selectedCountry))
            }
        
            Toggle(viewModel.state.viewModel.switchTitle, isOn: $isOn)
                .toggleStyle(.switch)
            
            HStack {
                Text(viewModel.state.viewModel.menuTitle)
                Picker("", selection: $selectedMenuItem) {
                    ForEach(viewModel.state.viewModel.menuItems, id: \.self) { item in
                        Text(item)
                    }
                }
                .pickerStyle(.menu)
                
            }
            
            HStack {
                TextField("Email", text: $textFieldText)
            }
            
            Button {
                viewModel.handle(.continue(selectedCountry: selectedCountry,
                                           isSwitchOn: isOn,
                                           selectedMenuItem: selectedMenuItem,
                                           textFieldText: textFieldText))
            } label: {
                Text("Continue")
            }
        }
    }
}

struct PredictionView_Previews: PreviewProvider {
    static var previews: some View {
        PredictionView(viewModel: PredictionViewModel(store: PredictionStore(validationProvider: ValidationService(), networkProvider: NetworkService())))
    }
}

