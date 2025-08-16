//
//  MoviesService.swift
//  TEA iOS Technical Task
//
//  Created by Mahmoud Ragab on 15/08/2025.
//

import Foundation

protocol MoviesServiceProtocol {
    func getMoviesList(page: Int) async throws -> [MoviesListDTO]
    func getMovieDetails(id: Int) async throws -> MovieDetailsDTO
}

final class MoviesService: MoviesServiceProtocol {
    var networkManager: NetworkSendableProtocol!
    
    init(networkManager: NetworkSendableProtocol) {
        self.networkManager = networkManager
    }

    func getMoviesList(page: Int) async throws -> [MoviesListDTO] {
        let endpoint = MoviesEndPoint.getMoviesList(page: page)
        do {
            // Perform the network request using async/await
            let movies: MoviesDTO = try await networkManager.send(
                model: MoviesDTO.self,
                endpoint: endpoint
            )
            return movies.results ?? []
        } catch {
            throw error
        }
    }
    
    func getMovieDetails(id: Int) async throws -> MovieDetailsDTO {
        let endpoint = MoviesEndPoint.getMovieDetails(id: id)
        do {
            // Perform the network request using async/await
            let movieDetails: MovieDetailsDTO = try await networkManager.send(
                model: MovieDetailsDTO.self,
                endpoint: endpoint
            )
            return movieDetails
        } catch {
            throw error
        }
    }
        
}
