//
//  MovieSearchModel.swift
//  Moviegram
//
//  Created by 이빈 on 1/28/25.
//

import Foundation

struct MovieSearchModel: Decodable {
    let page: Int
    let results: [MovieModel]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
