//
//  NetworkManager.swift
//  Moviegram
//
//  Created by 이빈 on 1/27/25.
//

import Foundation
import Alamofire

// MARK: - 네트워크
final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() { }
    
    func getMovieData<T: Decodable>(api: Router,
                                    type: T.Type,
                                    completionHandler: @escaping (T) -> Void) {
        
        AF.request(
            api.endpoint,
            method: api.method,
            parameters: api.parameters,
            encoding: URLEncoding.queryString,
            headers: api.header
        ).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completionHandler(value)
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

