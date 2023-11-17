//
//  MovieDetailViewModel.swift
//  SimpleAPIListing
//
//  Created by Seemanta on 2023-11-17.
//
import Foundation

final class MovieDetailViewModel: ObservableObject {

    @Published private(set) var movieDetails: MovieDetails?
    @Published private(set) var errorText: String?

    let dataProvider: DetailDataProvider

    init(dataProvider: DetailDataProvider) {
        self.dataProvider = dataProvider
        fetchData()
    }

    func fetchData() {
        Task { [weak self] in
            let result = await self?.dataProvider.getData()
            switch result {
            case .success(let response):
                await self?.update(with: response)
            case .failure(let failure):
                await self?.update(with: nil, error: failure.description)
            case .none: break
            }
        }
    }

    @MainActor private func update(with details: MovieDetails?, error: String? = nil) {
        movieDetails = details
        errorText = error
    }
}
