//
//  ProfileImageCollectionViewCell.swift
//  Moviegram
//
//  Created by 이빈 on 1/25/25.
//

import UIKit
import SnapKit

final class ProfileImageCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "ProfileImageCollectionViewCell"
    
    let profileImageView = ProfileImageCustomView()
    
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
    
    override func configureHierarchy() {
        addSubview(profileImageView)
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
