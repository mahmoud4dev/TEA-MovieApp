//
//  MovieDetailsLocal.swift
//  TEA iOS Technical Task
//
//  Created by Mahmoud Ragab on 15/08/2025.
//

import Foundation

extension MovieDetailsLocal {
    func mapToDto() -> MovieDetailsDTO {
        let model = MovieDetailsDTO(genres: genres as? [Genre], overview: overview, posterPath: posterPath, releaseDate: releaseDate, runtime: Int(runtime), isFavorite: isFavorite)
        return model
    }

    func populate(with model: MovieDetailsDTO, movieId: Int) {
        posterPath = model.posterPath
        releaseDate = model.releaseDate
        overview = model.overview
        runtime = Int64(model.runtime ?? 0)
        genres = genres
        isFavorite = isFavorite
        id = Int64(movieId)
    }
}
