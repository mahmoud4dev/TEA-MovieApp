//
//  MoviesViewModel.swift
//  TEA iOS Technical Task
//
//  Created by Mahmoud Ragab on 15/08/2025.
//

import Foundation

class MoviesViewModel: NSObject {
    // MARK: - Properties -

    @Published var error: Error?
    @Published var loading: Bool = false
    @Published var items: [MoviesListData] = []
    @Published var remoteData: [MoviesListData] = []
    var currentPage: Int = 1
    var MoviesFlow: MoviesFlow?
    
    private let moviesUseCase: MoviesUseCase

    init(moviesUseCase: MoviesUseCase) {
        self.moviesUseCase = moviesUseCase
    }

    func showIndicator() {
        AppIndicator.shared.show(isGif: true)
    }

    func hideIndicator() {
        AppIndicator.shared.dismiss()
    }
}

// MARK: - Networking -

extension MoviesViewModel {
    func fetchPlayingData() {
        loading = true
        Task {
            do {
                let moviesResult = try await moviesUseCase.getMoviesList(page: currentPage)
                let moviesData = moviesResult.map { $0.mapToPresentation() }
                self.currentPage += 1
                remoteData += moviesData
                items.removeAll()
                items = remoteData
                
            } catch {
                self.error = error
            }
            loading = false
        }
    }

    func updateIsFavorite(id: Int, value: Bool) {
        loading = true
        Task {
            do {
                let _ = try await moviesUseCase.updateIsFavorite(id: id, value: value)
                
            } catch {
                self.error = error
            }
        }
        loading = false
    }
}
