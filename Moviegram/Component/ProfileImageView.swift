//
//  ProfileImageView.swift
//  Moviegram
//
//  Created by 이빈 on 1/25/25.
//

import UIKit
import SnapKit

// 프로필 이미지 커스텀 뷰
class ProfileImageView: BaseView {
    
    let profileImageView = UIImageView()
    var imageNumber: Int = 0
    var isSelected: Bool = false
    
    convenience init(imageNumber: Int, isSelected: Bool) {
        self.init()
        self.imageNumber = imageNumber
        self.isSelected = isSelected
        configureView() // 부모 클래스로 인해, 자식이 생성되기 전에 먼저 실행돼버리는 이슈로 재호출.
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
