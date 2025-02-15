//
//  RecentKeywordCollectionViewCell.swift
//  Moviegram
//
//  Created by 이빈 on 1/30/25.
//

import UIKit
import SnapKit

// MARK: - Protocol: 키워드 삭제 Delegate
protocol DeleteKeywordDelegate: AnyObject {
    func deleteKeyword(index: Int)
}

// MARK: - 최근 검색 키워드 CollectionViewCell
final class RecentKeywordCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Properties
    static let identifier = "RecentKeywordCollectionViewCell"
    
    private let keywordView = UIView()
    private let keywordLabel = UILabel()
    private let xButton = UIButton()
    
    weak var delegate: DeleteKeywordDelegate?
    var index: Int?
    
    // MARK: - Configure UI
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
        xButton.addTarget(self, action: #selector(xButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Configure Data
    func configureData(text: String) {
        keywordLabel.text = text
    }
    
    // MARK: - Methods
    @objc private func xButtonTapped() {
        if let index {
            delegate?.deleteKeyword(index: index)
        }
    }
    
}
