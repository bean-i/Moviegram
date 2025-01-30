//
//  CreditData.swift
//  Moviegram
//
//  Created by 이빈 on 1/30/25.
//

import Foundation

struct CreditData: Decodable {
    let id: Int
    let cast: [Cast]
}

struct Cast: Decodable {
    let name: String?
    let character: String?
    let profile_path: String?
}
