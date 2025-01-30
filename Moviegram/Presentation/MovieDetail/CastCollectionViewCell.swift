//
//  CastCollectionViewCell.swift
//  Moviegram
//
//  Created by 이빈 on 1/30/25.
//

import UIKit
import Kingfisher
import SnapKit

final class CastCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "CastCollectionViewCell"
    
    let castImageView = UIImageView()
    let castNameLabel = UILabel()
    let movieCharacterNameLabel = UILabel()
    
    override func configureHierarchy() {
        addSubViews(
            castImageView,
            castNameLabel,
            movieCharacterNameLabel
        )
    }
    
    override func configureLayout() {
        castImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.size.equalTo(60)
        }
        
        castNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(castImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
        }
        
        movieCharacterNameLabel.snp.makeConstraints { make in
            make.top.equalTo(castNameLabel.snp.bottom).offset(5)
            make.leading.equalTo(castImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
        }
    }
    
    override func configureView() {
        castImageView.clipsToBounds = true
        castImageView.contentMode = .scaleAspectFill
        castImageView.layer.cornerRadius = 30
        
        castNameLabel.font = .Font.medium.of(weight: .bold)
        castNameLabel.textColor = .white
        castNameLabel.textAlignment = .left
        castNameLabel.numberOfLines = 1
        
        movieCharacterNameLabel.font = .Font.small.of(weight: .light)
        movieCharacterNameLabel.textColor = .customLightGray
        movieCharacterNameLabel.textAlignment = .left
        movieCharacterNameLabel.numberOfLines = 1
    }
    
    func configureData(data: Cast) {
        
        if let path = data.profile_path,
           let url = URL(string: TMDBAPI.imageBaseURL + path) {
            castImageView.kf.setImage(with: url)
        }
        
        castNameLabel.text = data.name
        movieCharacterNameLabel.text = data.character
        
    }
    
    
}
