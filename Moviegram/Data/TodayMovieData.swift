//
//  TodayMovieData.swift
//  Moviegram
//
//  Created by 이빈 on 1/27/25.
//

import Foundation

struct TodayMovieData: Decodable {
    let page: Int
    let results: [Movie]
}
