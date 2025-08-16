//
//  MovieDetailsUseCase.swift
//  TEA iOS Technical Task
//
//  Created by Mahmoud Ragab on 15/08/2025.
//

import Foundation

protocol MovieDetailsUseCase {
    func getMovieDetails(id: Int) async throws -> MovieDetailsModel
    func updateIsFavorite(id: Int , value: Bool) async throws -> Bool
}

class DefaultMovieDetailsUseCase: MovieDetailsUseCase {
    private let moviesRepository: MoviesRepositoryProtocol

    init(moviesRepository: MoviesRepositoryProtocol) {
        self.moviesRepository = moviesRepository
    }

    func getMovieDetails(id: Int) async throws -> MovieDetailsModel {
        return try await moviesRepository.getMovieDetails(id: id)
    }

    func updateIsFavorite(id: Int , value: Bool) async throws -> Bool {
        return try await moviesRepository.updateIsFavorite(id: id , value: value)
    }

}
