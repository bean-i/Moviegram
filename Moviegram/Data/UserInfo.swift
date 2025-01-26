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
    
    var storedMovies: [String]? {
        get {
            UserDefaults.standard.stringArray(forKey: storedMoviesKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: storedMoviesKey)
        }
    }
    
}
