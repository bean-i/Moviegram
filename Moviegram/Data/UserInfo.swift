//
//  UserInfo.swift
//  Moviegram
//
//  Created by 이빈 on 1/26/25.
//

import Foundation

// MARK: - UserDefaults의 Key
enum UserInfoKey: String, CaseIterable {
    case isRegisteredKey = "isRegistered"
    case nicknameKey = "nickname"
    case imageNumberKey = "imageNumber"
    case joinDateKey = "joinDate"
    case storedMoviesKey = "storedMovies"
    case recentKeywordsKey = "recentKeywords"
    case mbtiKey = "mbti"
}

// MARK: - UserInfo 싱글톤 패턴
final class UserInfo {
    
    static let shared = UserInfo()
    
    private init() { }
    
    // 좋아요 누른 영화 리스트: UserDefaults에 저장할 집합 (중복 X)
    static var storedMovieList: Set<Int> = Set(UserInfo.shared.storedMovies ?? [])
    
    // MARK: - 가입 이력
    var isRegistered: Bool {
        get {
            UserDefaults.standard.bool(forKey: UserInfoKey.isRegisteredKey.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserInfoKey.isRegisteredKey.rawValue)
        }
    }
    
    // MARK: - 닉네임
    var nickname: String? {
        get {
            UserDefaults.standard.string(forKey: UserInfoKey.nicknameKey.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserInfoKey.nicknameKey.rawValue)
        }
    }
    
    // MARK: - 프로필 이미지
    var imageNumber: Int? {
        get {
            UserDefaults.standard.integer(forKey: UserInfoKey.imageNumberKey.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserInfoKey.imageNumberKey.rawValue)
        }
    }
    
    // MARK: - 가입 날짜
    var joinDate: String? {
        get {
            UserDefaults.standard.string(forKey: UserInfoKey.joinDateKey.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserInfoKey.joinDateKey.rawValue)
        }
    }
    
    // MARK: - 보관 중인 영화
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
    
    // MARK: - 최근 검색어
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
    
    // MARK: - MBTI
    var mbti: [String]? {
        get {
            UserDefaults.standard.stringArray(forKey: UserInfoKey.mbtiKey.rawValue) ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey:     UserInfoKey.mbtiKey.rawValue)
        }
    }
    
}
