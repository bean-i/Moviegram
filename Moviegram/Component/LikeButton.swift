//
//  LikeButton.swift
//  Moviegram
//
//  Created by 이빈 on 1/27/25.
//

import UIKit

protocol LikeButtonDelegate: AnyObject {
    func likeButtonTapped(id: Int, isSelected: Bool)
}

final class LikeButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureButton() {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        self.configuration = config
        self.setImage(UIImage(systemName: "heart"), for: .normal)
        self.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        self.tintColor = .point
    }

    
}
