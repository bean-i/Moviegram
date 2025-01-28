//
//  String+.swift
//  Moviegram
//
//  Created by 이빈 on 1/28/25.
//

import Foundation

extension String {
    // 2014-12-18 문자열을
    // 2014. 12. 18로 만들어서 반환
    func convertDateString() -> String {
        return self.replacingOccurrences(of: "-", with: ". ")
    }
    
}
