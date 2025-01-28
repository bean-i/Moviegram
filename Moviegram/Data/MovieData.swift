//
//  MovieData.swift
//  Moviegram
//
//  Created by 이빈 on 1/28/25.
//

import Foundation

struct Movie: Decodable {
    let id: Int
    let backdropURL: String
    let title: String
    let overview: String
    let posterURL: String
    let genreID: [Int]
    let releaseDate: String
    let averageRating: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case backdropURL = "backdrop_path"
        case title
        case overview
        case posterURL = "poster_path"
        case genreID = "genre_ids"
        case releaseDate = "release_date"
        case averageRating = "vote_average"
    }
}
