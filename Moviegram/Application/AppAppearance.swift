//
//  AppAppearance.swift
//  Moviegram
//
//  Created by 이빈 on 1/24/25.
//

import UIKit

final class AppAppearance {
    
    static func configureAppearance() {
        
        // MARK: - 네비게이션바
        UINavigationBar.appearance().tintColor = .point
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
    }
    
}
