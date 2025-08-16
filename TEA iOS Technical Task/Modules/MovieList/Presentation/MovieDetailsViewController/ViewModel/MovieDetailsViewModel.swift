//
//  MovieDetailsViewModel.swift
//  TEA iOS Technical Task
//
//  Created by Mahmoud Ragab on 15/08/2025.
//

import Foundation

class MovieDetailsViewModel: NSObject {
    // MARK: - Properties -

    @Published var error: Error?
    @Published var loading: Bool = false
    @Published var detailsData: MovieDetailsData?
    var movieId: Int
    private let movieDetailsUseCase: MovieDetailsUseCase
    var movieDetailsFlow: MovieDetailsFlow?

    init(movieId: Int, movieDetailsUseCase: MovieDetailsUseCase) {
        self.movieId = movieId
        self.movieDetailsUseCase = movieDetailsUseCase
    }
    
    func showIndicator() {
        AppIndicator.shared.show(isGif: true)
    }
    
    func hideIndicator() {
        AppIndicator.shared.dismiss()
    }
}

// MARK: - Networking -

extension MovieDetailsViewModel {
    func fetchMovieDetails() {
        loading = true
        Task {
            do {
                let movieDetailsResult = try await movieDetailsUseCase.getMovieDetails(id: movieId)
                let movieDetailsData = movieDetailsResult.mapToPresentation()
                print(movieDetailsData)
                detailsData = movieDetailsData
            } catch {
                self.error = error
            }
            loading = false
        }
    }
    
    func updateIsFavorite() {
        loading = true
        Task {
            do {
                let currentStateIsFav = (detailsData?.isFavorite ?? false)
                let sucess = try await movieDetailsUseCase.updateIsFavorite(id: movieId, value: !currentStateIsFav)
                if sucess {
                    detailsData?.isFavorite = !currentStateIsFav
                }
            } catch {
                self.error = error
            }
        }
        loading = false
    }
}

