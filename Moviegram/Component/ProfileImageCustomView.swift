//
//  ProfileImageCustomView.swift
//  Moviegram
//
//  Created by 이빈 on 1/25/25.
//

import UIKit
import SnapKit

// 프로필 이미지 커스텀 뷰
final class ProfileImageCustomView: BaseView {
    
    let profileImageView = UIImageView()
    var imageNumber: Int = 0 {
        didSet {
            self.configureView()
        }
    }
    var isSelected: Bool = false {
        didSet {
            self.configureView()
        }
    }
    
    convenience init(imageNumber: Int, isSelected: Bool) {
        self.init()
        self.imageNumber = imageNumber
        self.isSelected = isSelected
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
    }
    
    override func configureHierarchy() {
        addSubview(profileImageView)
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        profileImageView.isUserInteractionEnabled = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.image = UIImage(named: "profile_\(String(imageNumber))")
        profileImageView.clipsToBounds = true
        
        profileImageView.layer.borderColor = isSelected ? UIColor.point.cgColor : UIColor.darkGray.cgColor
        profileImageView.alpha = isSelected ? 100 : 50
        profileImageView.layer.borderWidth = isSelected ? 3 : 1
    }

}
