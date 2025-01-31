//
//  DistributeView.swift
//  Moviegram
//
//  Created by 이빈 on 1/30/25.
//

import UIKit
import SnapKit

// [영화 상세 화면] - '개봉일, 평점, 장르' 정보를 구분하는 "|" 표시
final class DistributeView: BaseView {

    private let distributeLabel = UILabel()
    
    override func configureHierarchy() {
        addSubview(distributeLabel)
    }
    
    override func configureLayout() {
        distributeLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
    
    override func configureView() {
        distributeLabel.text = "|"
        distributeLabel.font = .Font.large.of(weight: .light)
        distributeLabel.textColor = .customGray
    }

}
