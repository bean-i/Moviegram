//
//  MBTICollectionViewCell.swift
//  Moviegram
//
//  Created by 이빈 on 2/8/25.
//

import UIKit
import SnapKit

final class MBTICollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "MBTICollectionViewCell"
    
    let backView = UIView()
    let mbtiLabel = UILabel()
    override var isSelected: Bool {
        didSet {
            if isSelected {
                configureIsSelected()
            } else {
                configureIsDeselected()
            }
        }
    }
    
    override func configureHierarchy() {
        contentView.addSubViews(
            backView,
            mbtiLabel
        )
    }
    
    override func configureLayout() {
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mbtiLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func configureView() {
        backView.backgroundColor = .clear
        backView.layer.cornerRadius = 30
        backView.layer.borderColor = UIColor.lightGray.cgColor
        backView.layer.borderWidth = 1
        
        mbtiLabel.font = .Font.large.of(weight: .medium)
        mbtiLabel.textColor = .lightGray
    }
    
    func configureData(data: String) {
        mbtiLabel.text = data
    }
    
    func configureIsSelected() {
        backView.backgroundColor = .point
        backView.layer.borderColor = UIColor.point.cgColor
        mbtiLabel.textColor = .white
    }
    
    func configureIsDeselected() {
        backView.backgroundColor = .clear
        backView.layer.borderColor = UIColor.lightGray.cgColor
        mbtiLabel.textColor = .lightGray
    }
    
}
