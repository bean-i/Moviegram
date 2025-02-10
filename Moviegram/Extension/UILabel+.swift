//
//  UILabel+.swift
//  Moviegram
//
//  Created by 이빈 on 2/10/25.
//

import UIKit

extension UILabel {
    
    func calculateNumberOfLines() -> Int {
        
        self.layoutIfNeeded()
        
        guard let text = self.text as? NSString,
              let font = self.font else {
            return 0
        }
        
        let attributes = [NSAttributedString.Key.font: font as Any]
        
        let labelSize = text.boundingRect(
            with: CGSize(width: self.bounds.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: attributes,
            context: nil
        )
        
        print("Label Size: ", labelSize)
        print("Font Height", font.lineHeight)
        
        return Int(ceil(CGFloat(labelSize.height) / font.lineHeight))
    }
    
}
