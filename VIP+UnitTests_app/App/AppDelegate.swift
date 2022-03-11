//
//  AppDelegate.swift
//  internship_app
//
//  Created by Vadym Boiko on 02.03.2022.
//

import SwiftUI

@main
struct AppDelegate: App {
    var body: some Scene {
        WindowGroup {
            PredictionView(viewModel: PredictionViewModel(store: PredictionStore(validationProvider: ValidationService(), networkProvider: NetworkService())))
        }
    }
}

//TODO: Add onboarding and navigation
//            GoalsView(viewModel: GoalsViewModel(store: GoalsStore(userProvider: RealmStorage())))
