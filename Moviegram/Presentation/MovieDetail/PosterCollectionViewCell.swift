//
//  PosterCollectionViewCell.swift
//  Moviegram
//
//  Created by 이빈 on 1/30/25.
//

import UIKit
import Kingfisher
import SnapKit

final class PosterCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "PosterCollectionViewCell"
    
    private let posterImageView = UIImageView()
    
    override func configureHierarchy() {
        addSubview(posterImageView)
    }
    
    override func configureLayout() {
        posterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        posterImageView.contentMode = .scaleAspectFill
    }
    
    func configureData(url: String?) {
        if let url,
           let imageURL = URL(string: TMDBAPI.imageBaseURL + url) {
            posterImageView.kf.setImage(with: imageURL)
        }
    }
    
}
