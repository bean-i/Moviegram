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
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().tintColor = .point
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
    }
    
}
