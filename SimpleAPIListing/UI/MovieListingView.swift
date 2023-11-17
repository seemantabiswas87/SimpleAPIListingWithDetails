//
//  MovieListingView.swift
//  SimpleAPIListing
//
//  Created by Seemanta on 2023-11-17.
//

import SwiftUI

struct MovieListingView: View {

    init(viewModel: MovieListingViewModel) {
        self.viewModel = viewModel
    }

    @ObservedObject var viewModel: MovieListingViewModel
    @State private var showModal = false
    @State private var sheetHeight: CGFloat = 300

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                if let error = viewModel.errorText {
                    VStack(alignment: .center) {
                        DesignText(error, style: .bodyBold, overrideForegroundColor: .primary)
                            .multilineTextAlignment(.center)
                    }

                } else if let list = viewModel.displayList {
                    LazyVStack(spacing: Spacing.spacing16) {
                        ForEach(list) { movie in
                            VStack {
                                NavigationLink {
                                    viewModel.getDetailView(movieId: movie.id)
                                } label: {
                                    MovieListItemView(imageURL: movie.makeImageUrl(), title: movie.title, description: movie.description)
                                }
                            }
                        }
                    }
                } else {
                    ProgressView()

                }
            }
            .navigationTitle("Movies")
        }

        .navigationViewStyle(.stack)
    }
}


