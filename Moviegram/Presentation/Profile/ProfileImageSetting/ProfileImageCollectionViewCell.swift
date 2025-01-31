//
//  ProfileImageCollectionViewCell.swift
//  Moviegram
//
//  Created by 이빈 on 1/25/25.
//

import UIKit
import SnapKit

// MARK: - 프로필 이미지 CollectionViewCell
final class ProfileImageCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Properties
    static let identifier = "ProfileImageCollectionViewCell"
    
    private let profileImageView = ProfileImageView()
    
    var imageNumber: Int = 0 {
        didSet {
            profileImageView.imageNumber = self.imageNumber
        }
    }
    
    override var isSelected: Bool {
        didSet {
            profileImageView.isSelected = self.isSelected
        }
    }
    
    // MARK: - Configure UI
    override func configureHierarchy() {
        addSubview(profileImageView)
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
