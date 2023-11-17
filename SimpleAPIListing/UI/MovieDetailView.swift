//
//  MovieDetailView.swift
//  SimpleAPIListing
//
//  Created by Seemanta on 2023-11-17.
//

import SwiftUI

struct MovieDetailView: View {

    init(viewModel: MovieDetailViewModel) {
        self.viewModel = viewModel
    }
    @ObservedObject private var viewModel: MovieDetailViewModel
    var body: some View {
        NavigationView {

            ScrollView(showsIndicators: false) {
                if let error = viewModel.errorText {
                    VStack(alignment: .center) {
                        DesignText(error, style: .bodyBold, overrideForegroundColor: .primary)
                            .multilineTextAlignment(.center)
                    }
                } else if let details = viewModel.movieDetails{
                    VStack(alignment: .center, spacing: Spacing.spacing16) {
                        DesignText(details.title, style: .titleBold)
                        AsyncCachedImage(url: details.makeImageUrl(),
                                   content: { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)

                        })


                        DesignText(details.description, style: .subtitleRegular, overrideForegroundColor: .gray)
                            .padding(.horizontal, Spacing.spacing8)


                        VStack(spacing: Spacing.spacing8) {
                            HStack() {
                                DesignText("Release Date", style: .subtitleRegular)
                                    .foregroundColor(.secondary)
                                Spacer()
                                DesignText(details.releaseDate, style: .subtitleBold)
                                    .foregroundColor(.primary)

                            }

                            HStack() {
                                DesignText("Run Time", style: .subtitleRegular)
                                    .foregroundColor(.secondary)
                                Spacer()
                                DesignText("\(details.runtime) mins", style: .subtitleBold)
                                    .foregroundColor(.primary)

                            }

                            HStack() {
                                DesignText("Rating", style: .subtitleRegular)
                                    .foregroundColor(.secondary)
                                Spacer()
                                DesignText("\(details.rating)/10", style: .subtitleBold)
                                    .foregroundColor(.primary)

                            }
                        }
                        .padding(.horizontal, Spacing.spacing8)

                    }
                } else {
                    ProgressView()
                }
            }

        }
    }

}

