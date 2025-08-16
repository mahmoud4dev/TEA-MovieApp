//
//  MoviesRepositoryProtocol.swift
//  TEA iOS Technical Task
//
//  Created by Mahmoud Ragab on 15/08/2025.
//

import Foundation

protocol MoviesRepositoryProtocol {
    func getMoviesList(page: Int) async throws -> [MoviesListModel]
    func getMovieDetails(id: Int) async throws -> MovieDetailsModel
    func updateIsFavorite(id: Int , value: Bool) async throws -> Bool
}
