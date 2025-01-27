//
//  Router.swift
//  Moviegram
//
//  Created by 이빈 on 1/27/25.
//

import Foundation
import Alamofire

enum Router {
    
    case TodayMovie
    
    var baseURL: String {
        return "https://api.themoviedb.org/3"
    }
    
    var endpoint: URL {
        switch self {
        case .TodayMovie:
            return URL(string: baseURL + "/trending/movie/day")!
        }
    }
    
    var header: HTTPHeaders {
        return ["Authorization": "Bearer \(TMDBAPI.accessToken)"]
    }
    
    var method: HTTPMethod {
        switch self {
        case .TodayMovie:
            return .get
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .TodayMovie:
            return [
                "language": "ko-KR",
                "page": "1"
            ]
        }
    }
    
}
