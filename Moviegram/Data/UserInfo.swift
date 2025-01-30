//
//  UserInfo.swift
//  Moviegram
//
//  Created by 이빈 on 1/26/25.
//

import Foundation

enum UserInfoKey: String, CaseIterable {
    case nicknameKey = "nickname"
    case imageNumberKey = "imageNumber"
    case joinDateKey = "joinDate"
    case storedMoviesKey = "storedMovies"
    case recentKeywordsKey = "recentKeywords"
}

final class UserInfo {
    
    static let shared = UserInfo()
    
    private init() { }
    
    // 좋아요 누른 영화 리스트 + UserDefaults에 저장할 배열
    static var storedMovieList: Set<Int> = Set(UserInfo.shared.storedMovies ?? [])
    
    var nickname: String? {
        get {
            UserDefaults.standard.string(forKey: UserInfoKey.nicknameKey.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserInfoKey.nicknameKey.rawValue)
        }
    }
    
    var imageNumber: Int? {
        get {
            UserDefaults.standard.integer(forKey: UserInfoKey.imageNumberKey.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserInfoKey.imageNumberKey.rawValue)
        }
    }
    
    var joinDate: String? {
        get {
            UserDefaults.standard.string(forKey: UserInfoKey.joinDateKey.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserInfoKey.joinDateKey.rawValue)
        }
    }
    
    var storedMovies: [Int]? {
        get {
            UserDefaults.standard.object(forKey: UserInfoKey.storedMoviesKey.rawValue) as? [Int]
        }
        set {
            if let addMovies = newValue {
                for movie in addMovies {
                    UserInfo.storedMovieList.insert(movie) // 집합에 넣어주기
                }
                UserDefaults.standard.set(Array(UserInfo.storedMovieList), forKey: UserInfoKey.storedMoviesKey.rawValue)
            }
        }
    }
    
    var recentKeywords: [String]? {
        get {
            UserDefaults.standard.stringArray(forKey: UserInfoKey.recentKeywordsKey.rawValue) ?? []
        }
        set {
            var newKeywords = recentKeywords
            
            if let addKeywords = newValue {
                for keyword in addKeywords {
                    newKeywords?.append(keyword)
                }
            }
            
            UserDefaults.standard.set(newKeywords, forKey: UserInfoKey.recentKeywordsKey.rawValue)
            
        }
    }
    
}
