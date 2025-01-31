//
//  MovieInfoView.swift
//  Moviegram
//
//  Created by 이빈 on 1/30/25.
//

import UIKit
import SnapKit

// [영화 상세 화면] - '개봉일, 평점, 장르'를 나타내는 뷰
final class MovieInfoView: BaseView {

    private let imageView = UIImageView()
    private let infoLabel = UILabel()
    
    override func configureHierarchy() {
        addSubViews(
            imageView,
            infoLabel
        )
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.size.equalTo(15)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview()
            make.leading.equalTo(imageView.snp.trailing).offset(5)
        }
        
    }
    
    override func configureView() {
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .customGray
        
        infoLabel.font = .Font.small.of(weight: .medium)
        infoLabel.textColor = .customGray
    }
    
    func configureData(image: String, text: String) {
        imageView.image = UIImage(systemName: image)
        infoLabel.text = text
    }

}
