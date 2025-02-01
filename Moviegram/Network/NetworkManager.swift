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
                                    completionHandler: @escaping (T) -> Void,
                                    failHandler: @escaping (StatusCode) -> Void) {
        
        guard let endpoint = api.endpoint else {
            failHandler(.badRequest)
            return
        }
        
        AF.request(endpoint,
                   method: api.method,
                   parameters: api.parameters,
                   encoding: URLEncoding.queryString,
                   headers: api.header)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completionHandler(value)
            case .failure(let error):
                if let errorCode = error.responseCode {
                    switch errorCode {
                    case 400..<500:
                        failHandler(.badRequest)
                    case 500..<600:
                        failHandler(.serverError)
                    default:
                        failHandler(.unknownError)
                    }
                } else {
                    failHandler(.unknownError)
                }
            }
        }
    }
    
}

