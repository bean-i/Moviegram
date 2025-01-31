//
//  PosterCollectionViewCell.swift
//  Moviegram
//
//  Created by 이빈 on 1/30/25.
//

import UIKit

import Kingfisher
import SnapKit

// MARK: - 포스터 CollectionViewCell
final class PosterCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Properties
    static let identifier = "PosterCollectionViewCell"
    
    private let posterImageView = UIImageView()
    
    // MARK: - Configure UI
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
    
    // MARK: - Configure Data
    func configureData(url: String?) {
        if let url,
           let imageURL = URL(string: TMDBAPI.imageBaseURL + url) {
            posterImageView.kf.setImage(with: imageURL)
        }
    }
    
}
