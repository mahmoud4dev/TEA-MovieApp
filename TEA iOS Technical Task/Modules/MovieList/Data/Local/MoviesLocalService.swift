//
//  MoviesLocalService.swift
//  TEA iOS Technical Task
//
//  Created by Mahmoud Ragab on 15/08/2025.
//

import Foundation

protocol MoviesLocalServiceProtocol {
    func getMoviesList(page: Int) -> [MoviesListDTO]
    func insertMoviesList(items: [MoviesListDTO], page: Int)
    func getMovieDetails(id: Int) -> MovieDetailsDTO?
    func insertMovieDetails(_ item: MovieDetailsDTO)
    func updateIsFavorite(id: Int, value: Bool) -> Bool
}

class MoviesLocalServiceManager: MoviesLocalServiceProtocol {
    var localDbManager: LocalDbManager!

    init(localDbManager: LocalDbManager) {
        self.localDbManager = localDbManager
    }

    func getMoviesList(page: Int) -> [MoviesListDTO] {
        var result: [MoviesLocal]
        result = localDbManager.getAllObjects(MoviesLocal.self, where: "page == \(page)")
        let movieList = result.map { $0.mapToDto() }
        return movieList
    }

    func insertMoviesList(items: [MoviesListDTO], page: Int) {
        let entities = items.map { item -> MoviesLocal in
            let entity = localDbManager.createEntity(MoviesLocal.self)
            entity.createdAt = Date()
            entity.populate(with: item, pageNo: page)
            return entity
        }

        localDbManager.saveObjects(entities)
    }

    func getMovieDetails(id: Int) -> MovieDetailsDTO? {
        // check is fav in movies list
        let isFavorite = localDbManager.getAllObjects(MoviesLocal.self, where: "id == \(id)").first?.isFavorite
        guard let result = localDbManager.getAllObjects(MovieDetailsLocal.self, where: "id == \(id)").first else {
            return nil
        }
        result.isFavorite = isFavorite ?? false
        return result.mapToDto()
    }

    func insertMovieDetails(_ item: MovieDetailsDTO) {
        if let existing = localDbManager.getAllObjects(MovieDetailsLocal.self, where: "id == \(item.id ?? 0)").first {
            existing.populate(with: item, movieId: item.id ?? 0) // Update existing record
            localDbManager.saveObjects([existing])
        } else {
            let entity = localDbManager.createEntity(MovieDetailsLocal.self)
            entity.populate(with: item, movieId: item.id ?? 0)
            localDbManager.saveObjects([entity]) // Save as list
        }
    }

    func updateIsFavorite(id: Int, value: Bool) -> Bool {
        let updateMovieDetailsLocal = localDbManager.updateObject(
            MovieDetailsLocal.self,
            where: "id == \(id)",
            with: ["isFavorite": value]
        )
        let updateMoviesLocal = localDbManager.updateObject(
            MoviesLocal.self,
            where: "id == \(id)",
            with: ["isFavorite": value]
        )

        return updateMoviesLocal || updateMovieDetailsLocal
    }
}
