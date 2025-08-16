//
//  MoviesModel.swift
//  TEA iOS Technical Task
//
//  Created by Mahmoud Ragab on 15/08/2025.
//

import Foundation

// MARK: - MoviesModel -
struct MoviesModel: Codable, Equatable {
    var dates: DatesModel?
    var page: Int?
    var results: [MoviesListModel]?
    var totalPages, totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - DatesModel -
struct DatesModel: Codable, Equatable {
    var maximum, minimum: String?
}

// MARK: - MoviesListModel -
struct MoviesListModel: Codable, Equatable {
    var adult: Bool?
    var backdropPath: String?
    var genreIDS: [Int]?
    var id: Int?
    var originalLanguage: String?
    var originalTitle, overview: String?
    var popularity: Double?
    var posterPath, releaseDate, title: String?
    var video: Bool?
    var voteAverage: Double?
    var voteCount: Int?
    var isFavorite: Bool?

    func mapToPresentation() -> MoviesListData {
        let model = MoviesListData()
        if let jsonString = toString() {
            if let domainModel: MoviesListData = jsonString.toObject() {
                return domainModel
            }
        }
        return model
    }
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case isFavorite
    }
}
