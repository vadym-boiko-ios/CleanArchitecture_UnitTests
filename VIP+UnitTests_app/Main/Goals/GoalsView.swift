//
//  ContentView.swift
//  internship_app
//
//  Created by Vadym Boiko on 02.03.2022.
//

import SwiftUI

struct GoalsView: View {
    @ObservedObject var viewModel: GoalsViewModel
    
    init(viewModel: GoalsViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            ForEach(viewModel.state.viewModels) { viewModel in
                GoalsRowView(viewModel: GoalsRowViewModel(title: viewModel.title,
                                                          isSelected: viewModel.isSelected))
            .onTapGesture {
                guard let index = self.viewModel.state.viewModels.firstIndex (where: { $0 == viewModel }) else { return }
                self.viewModel.handle(.select(index))
                }
            }
            
            Button {
                viewModel.handle(.selectAll)
            } label: {
                Text(viewModel.state.viewModels.contains(where: { $0.isSelected == true}) ?
                     "Deselect All" : "Select All")
            }
            
            Button {
                viewModel.handle(.done)
            } label: {
                Text("Submit")
            }
        }
    }
}


struct GoalsRowView: View {
    let viewModel: GoalsRowViewModel
    
    init(viewModel: GoalsRowViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        HStack {
            Image(systemName: viewModel.isSelected ? "square.fill" : "square")
                .foregroundColor(.cyan)
            Text(viewModel.title)
                .font(Font.headline)
        }
    }
}

struct GoalsRowViewModel {
    let title: String
    let isSelected: Bool
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GoalsView(viewModel: GoalsViewModel(store: GoalsStore(userProvider: RealmStorage())))
    }
}
