//
//  DateFormatter.swift
//  Moviegram
//
//  Created by 이빈 on 1/26/25.
//

import Foundation

extension DateFormatter {
    
    static let stringFromDate = { date in
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"
        formatter.locale = Locale(identifier: "ko-KR")
        formatter.timeZone = TimeZone.current
        return formatter.string(from: date)
    }
    
}
