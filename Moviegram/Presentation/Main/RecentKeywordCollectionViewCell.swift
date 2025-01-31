//
//  RecentKeywordCollectionViewCell.swift
//  Moviegram
//
//  Created by 이빈 on 1/30/25.
//

import UIKit
import SnapKit

final class RecentKeywordCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "RecentKeywordCollectionViewCell"
    
    private let keywordView = UIView()
    private let keywordLabel = UILabel()
    private let xButton = UIButton()
    
    override func configureHierarchy() {
        keywordView.addSubViews(
            keywordLabel,
            xButton
        )
        
        addSubview(keywordView)
    }
    
    override func configureLayout() {
        keywordView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        keywordLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(10)
        }
        
        xButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(keywordLabel.snp.trailing).offset(10)
            make.size.equalTo(10)
        }
    }
    
    override func configureView() {
        keywordView.backgroundColor = .white
        keywordView.layer.cornerRadius = 15
        
        keywordLabel.textColor = .black
        keywordLabel.font = .Font.medium.of(weight: .medium)
        
        xButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        xButton.tintColor = .black
    }
    
    func configureData(text: String) {
        keywordLabel.text = text
    }
    
}
