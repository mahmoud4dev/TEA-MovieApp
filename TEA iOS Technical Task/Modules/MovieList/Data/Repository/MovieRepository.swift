//
//  MovieRepository.swift
//  TEA iOS Technical Task
//
//  Created by Mahmoud Ragab on 15/08/2025.
//

import Foundation

final class MoviesRepository: MoviesRepositoryProtocol {
    var movieService: MoviesServiceProtocol
    var movieLocalService: MoviesLocalServiceProtocol
    private var hasMorePages = true
    
    init(movieService: MoviesServiceProtocol, movieLocalService: MoviesLocalServiceProtocol) {
        self.movieService = movieService
        self.movieLocalService = movieLocalService
    }
    
    func getMoviesList(page: Int) async -> [MoviesListModel] {
        // Check if the page is already fetched from local storage
        let movieListLocal = getMoviesFromLocal(page: page)
        // If the local list is empty, fetch from remote
        if movieListLocal.isEmpty {
            // Fetch from remote service
            let movieListRemote = await getMoviesFromRemote(page: page)
            movieLocalService.insertMoviesList(items: movieListRemote, page: page)
            return movieListRemote.map { $0.mapToDomain() }
        } else {
            return movieListLocal.map { $0.mapToDomain() }
        }
    }
    
    func getMoviesFromLocal(page: Int) -> [MoviesListDTO] {
        return movieLocalService.getMoviesList(page: page)
    }
    
    func getMoviesFromRemote(page: Int) async -> [MoviesListDTO] {
        guard hasMorePages else {
            return []
        }
        
        do {
            let movieDTO = try await movieService.getMoviesList(page: page)
            
            if movieDTO.isEmpty {
                hasMorePages = false
                return []
            }
            
            return movieDTO
        } catch {
            // Fetch from the local database in case of an error
            return getMoviesFromLocal(page: page)
        }
    }
    
    func getMovieDetails(id: Int) async throws -> MovieDetailsModel {
        // Check if the page is already fetched from local storage
        let movieDetailsLocal = getMovieDetailsFromLocal(id: id)
        // If the local list is empty, fetch from remote
        if movieDetailsLocal == nil {
            // Fetch from remote service
            let movieDetailsRemote = await getMoviesDetailsFromRemote(id: id)
            movieLocalService.insertMovieDetails(movieDetailsRemote)
            return getMovieDetailsFromLocal(id: id)?.mapToDomain() ?? MovieDetailsModel()
        } else {
            return movieDetailsLocal?.mapToDomain() ?? MovieDetailsModel()
        }
    }
    
    func getMovieDetailsFromLocal(id: Int) -> MovieDetailsDTO? {
        return movieLocalService.getMovieDetails(id: id)
    }
    
    func getMoviesDetailsFromRemote(id: Int) async -> MovieDetailsDTO {
        do {
            // Fetch data from the API
            let movieDetailsDTO = try await movieService.getMovieDetails(id: id)
            
            return movieDetailsDTO
        } catch {
            // If an error occurs, fetch from the local database
            return getMovieDetailsFromLocal(id: id) ?? MovieDetailsDTO()
        }
    }
    
    func updateIsFavorite(id: Int, value: Bool) async throws -> Bool {
        movieLocalService.updateIsFavorite(id: id, value: value)
    }
}
