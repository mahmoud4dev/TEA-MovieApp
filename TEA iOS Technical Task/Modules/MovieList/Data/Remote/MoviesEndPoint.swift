//
//  MoviesEndPoint.swift
//  TEA iOS Technical Task
//
//  Created by Mahmoud Ragab on 15/08/2025.
//

import Foundation

enum MoviesEndPoint: BaseEndpoint {
    case getMoviesList(page: Int)
    case getMovieDetails(id: Int)

    var path: String {
        switch self {
        case .getMoviesList:
            return "now_playing"
        case .getMovieDetails(id: let id):
            return "\(id)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getMoviesList:
            return .get
        case .getMovieDetails:
            return .get
        }
    }

    var parameters: Parameters {
        switch self {
        case .getMoviesList(let page):
            return ["page": page]
        case .getMovieDetails:
            return [:]
        }
    }
    
    var headers: Headers {
        return [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4NDY0ZGMwMjljM2Y5ODc5ODk2ZmEwY2MyZmU5NGEwZSIsIm5iZiI6MTczODI1MDQyMS40MjIwMDAyLCJzdWIiOiI2NzliOThiNWQwNGIwM2JkOWYzNDZhMTgiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.QeiM7LqAj7hyc9Z3c0MCG1B8b62FTBY3ptngjXZAQz4"
        ]
    }
}
