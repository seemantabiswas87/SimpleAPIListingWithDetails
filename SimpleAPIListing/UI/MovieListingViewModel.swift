//
//  MovieListingViewModel.swift
//  SimpleAPIListing
//
//  Created by Seemanta on 2023-11-17.
//

import Foundation

final class MovieListingViewModel: ObservableObject {

    @Published private(set) var displayList: [Movie]?

    private(set) var movieList: [Movie]?
    @Published private(set) var errorText: String?

    private var selectedGenreIds: [Int] = []

    let listingDataProvider: ListingDataProvider

    init() {
        ReachabilityMonitor.shared.startMonitoring()
        self.listingDataProvider = ListingDataProvider(apiDataProvider: MovieAPIDataProvider(), storageDataProvider: ListingStore(urlRequest: .listing))
        fetchData()
    }

    func fetchData() {
        Task { [weak self] in

            guard let strongSelf = self else { return }
            let result = await strongSelf.listingDataProvider.getData()

            switch result {
            case .success(let response):
                strongSelf.update(with: response.results)
            case .failure(let failure):
                strongSelf.update(with: nil, error: failure.description)
            }
        }
    }

    private func update(with movies: [Movie]?, error: String? = nil) {
        movieList = movies
        Task {
            await refreshView(with: movies, error: error)
        }
    }


    @MainActor private func refreshView(with movies: [Movie]?, error: String? = nil) {
        displayList = movies
        errorText = error

    }

    deinit {
        ReachabilityMonitor.shared.stopMonitoring()
    }
}

extension MovieListingViewModel {
    func getDetailView(movieId: Int) -> MovieDetailView {
        return MovieDetailView(viewModel: MovieDetailViewModel(
            dataProvider: DetailDataProvider(apiDataProvider: MovieDetailsAPIDataProvider(movieId: movieId), storageDataProvider: DetailStore(urlRequest: .details(id: movieId)))))
    }
}
