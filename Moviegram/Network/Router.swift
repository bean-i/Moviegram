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
    case MovieSearch(keyword: String, page: String)
    case MovieImage(id: Int)
    case Cast(id: Int)
    
    var endpoint: URL {
        switch self {
        case .TodayMovie:
            return URL(string: TMDBAPI.baseURL + "/trending/movie/day")!
        case .MovieSearch:
            return URL(string: TMDBAPI.baseURL + "/search/movie")!
        case .MovieImage(let id):
            return URL(string: TMDBAPI.baseURL + "/movie/\(id)/images")!
        case .Cast(let id):
            return URL(string: TMDBAPI.baseURL + "/movie/\(id)/credits")!
        }
    }
    
    var header: HTTPHeaders {
        return ["Authorization": "Bearer \(TMDBAPI.accessToken)"]
    }
    
    var method: HTTPMethod {
        switch self {
        case .TodayMovie:
            return .get
        case .MovieSearch:
            return .get
        case .MovieImage:
            return .get
        case .Cast:
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
        case .MovieSearch(let keyword, let page):
            return [
                "query": keyword,
                "include_adult": "false",
                "language": "ko-KR",
                "page": page
            ]
        case .MovieImage:
            return [:]
        case .Cast:
            return [
                "language": "ko-KR"
            ]
        }
    }
    
}
