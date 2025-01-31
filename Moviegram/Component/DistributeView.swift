//
//  DistributeView.swift
//  Moviegram
//
//  Created by 이빈 on 1/30/25.
//

import UIKit
import SnapKit

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
