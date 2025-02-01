//
//  StatusCode.swift
//  Moviegram
//
//  Created by 이빈 on 2/1/25.
//

import Foundation

enum StatusCode: String {
    case badRequest = "Bad Request" // 400번대
    case serverError = "Server Error" // 500번대
    case unknownError = "Unknown Error"
    
    var description: String {
        switch self {
        case .badRequest:
            return "잘못된 요청입니다. 다시 시도해 주세요."
        case .serverError:
            return "서버에 문제가 발생했습니다. 나중에 다시 시도해 주세요."
        case .unknownError:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}
