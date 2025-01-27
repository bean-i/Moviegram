//
//  NetworkManager.swift
//  Moviegram
//
//  Created by 이빈 on 1/27/25.
//

import Foundation
import Alamofire

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() { }
    
    func getTodayMovies(api: Router,
                        completionHandler: @escaping (TodayMovieData) -> Void) {
        
        AF.request(
            api.endpoint,
            method: api.method,
            parameters: api.parameters,
            encoding: URLEncoding.queryString,
            headers: api.header
        ).responseDecodable(of: TodayMovieData.self) { response in
            switch response.result {
            case .success(let value):
                completionHandler(value)
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

