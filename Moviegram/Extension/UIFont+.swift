//
//  UIFont+.swift
//  Moviegram
//
//  Created by 이빈 on 1/24/25.
//

import UIKit

extension UIFont {
    
    enum Font: CGFloat {
        case small = 12
        case medium = 14
        case large = 16
        
        func of(weight: UIFont.Weight) -> UIFont {
            return .systemFont(ofSize: self.rawValue, weight: weight)
        }
    }

}
