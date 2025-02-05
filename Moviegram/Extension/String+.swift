//
//  String+.swift
//  Moviegram
//
//  Created by 이빈 on 1/28/25.
//

import UIKit

extension String {
    // 2014-12-18 문자열을
    // 2014. 12. 18로 만들어서 반환
    func convertDateString() -> String {
        return self.replacingOccurrences(of: "-", with: ". ")
    }
    
    // 텍스트 길이 계산하기
    func calculateTextWidth(font: UIFont) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: font]
        let textSize = (self as NSString).size(withAttributes: attributes as [NSAttributedString.Key: Any])
        return textSize.width
    }
    
}
