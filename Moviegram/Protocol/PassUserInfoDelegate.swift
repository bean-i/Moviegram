//
//  PassUserInfoDelegate.swift
//  Moviegram
//
//  Created by 이빈 on 2/1/25.
//

import Foundation

// MARK: - Protocol
// Modal 화면에서 데이터 저장 시, 이전 화면의 데이터가 업데이트 되지 않음 -> 딜리게이트 사용하여 이전 뷰에 데이터 전달
protocol PassUserInfoDelegate: AnyObject {
    func passUserInfo()
}
