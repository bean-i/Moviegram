//
//  TodayMovieModel.swift
//  Moviegram
//
//  Created by 이빈 on 1/27/25.
//

import Foundation

struct TodayMovieModel: Decodable {
    let page: Int
    let results: [MovieModel]
}
