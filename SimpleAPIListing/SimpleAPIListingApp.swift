//
//  SimpleAPIListingApp.swift
//  SimpleAPIListing
//
//  Created by Seemanta on 2023-11-17.
//

import SwiftUI

@main
struct SimpleAPIListingApp: App {
    var body: some Scene {
        WindowGroup {
            MovieListingView(viewModel: MovieListingViewModel())
        }
    }
}
