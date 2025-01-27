//
//  UserInfo.swift
//  Moviegram
//
//  Created by 이빈 on 1/26/25.
//

import Foundation

class UserInfo {
    
    static let shared = UserInfo()
    
    private init() { }
    
    // 좋아요 누른 영화 리스트 + UserDefaults에 저장할 배열
    static var storedMovieList: Set<Int> = Set(UserInfo.shared.storedMovies ?? [])
    
    let nicknameKey = "nickname"
    let imageNumberKey = "imageNumber"
    let joinDateKey = "joinDate"
    let storedMoviesKey = "storedMovies"
    
    var nickname: String? {
        get {
            UserDefaults.standard.string(forKey: nicknameKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: nicknameKey)
        }
    }
    
    var imageNumber: Int? {
        get {
            UserDefaults.standard.integer(forKey: imageNumberKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: imageNumberKey)
        }
    }
    
    var joinDate: String? {
        get {
            UserDefaults.standard.string(forKey: joinDateKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: joinDateKey)
        }
    }
    
    var storedMovies: [Int]? {
        get {
            UserDefaults.standard.object(forKey: storedMoviesKey) as? [Int]
        }
        set {
            if let addMovies = newValue {
                for movie in addMovies {
                    UserInfo.storedMovieList.insert(movie) // 집합에 넣어주기
                }
                UserDefaults.standard.set(Array(UserInfo.storedMovieList), forKey: storedMoviesKey)
            }
        }
    }
    
}
