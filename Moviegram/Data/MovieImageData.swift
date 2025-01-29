//
//  MovieImageData.swift
//  Moviegram
//
//  Created by 이빈 on 1/29/25.
//

import Foundation

struct MovieImageData: Decodable {
    let id: Int
    let backdrops: [ImagePath]
    let posters: [ImagePath]
}

struct ImagePath: Decodable {
    let file_path: String
}
