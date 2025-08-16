//
//  MoviesUseCase.swift
//  TEA iOS Technical Task
//
//  Created by Mahmoud Ragab on 15/08/2025.
//

import Foundation

protocol MoviesUseCase {
    func getMoviesList(page: Int) async throws -> [MoviesListModel]
    func updateIsFavorite(id: Int, value: Bool) async throws -> Bool
}

class DefaultMoviesUseCase: MoviesUseCase {
    private let moviesRepository: MoviesRepositoryProtocol

    init(moviesRepository: MoviesRepositoryProtocol) {
        self.moviesRepository = moviesRepository
    }

    func getMoviesList(page: Int) async throws -> [MoviesListModel] {
        return try await moviesRepository.getMoviesList(page: page)
    }

    func updateIsFavorite(id: Int, value: Bool) async throws -> Bool {
        return try await moviesRepository.updateIsFavorite(id: id, value: value)
    }
}
