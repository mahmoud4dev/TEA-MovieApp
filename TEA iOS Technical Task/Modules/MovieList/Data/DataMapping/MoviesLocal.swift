//
//  MoviesLocal.swift
//  TEA iOS Technical Task
//
//  Created by Mahmoud Ragab on 15/08/2025.
//

import Foundation

extension MoviesLocal {
    func mapToDto() -> MoviesListDTO {
        let model = MoviesListDTO(id: Int(id), posterPath: posterPath, releaseDate: releaseDate, title: title, voteAverage: vote , isFavorite: isFavorite)
        return model
    }

    func populate(with model: MoviesListDTO, pageNo: Int) {
        posterPath = model.posterPath
        releaseDate = model.releaseDate
        title = model.title
        id = Int64(model.id ?? 0)
        page = Int64(pageNo)
        isFavorite = isFavorite
        vote = model.voteAverage ?? 0
    }
}
