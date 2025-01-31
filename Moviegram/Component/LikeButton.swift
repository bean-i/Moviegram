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
    
    weak var delegate: LikeButtonDelegate?
    var id: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButton() {
        self.configuration = UIButton.Configuration.customStyle(title: nil)
        self.setImage(UIImage(systemName: "heart"), for: .normal)
        self.setImage(UIImage(systemName: "heart.fill"), for: .selected)
    }
    
    @objc func buttonTapped() {
        isSelected.toggle()
        if let id {
            delegate?.likeButtonTapped(id: id, isSelected: isSelected)
        }
    }

    
}
