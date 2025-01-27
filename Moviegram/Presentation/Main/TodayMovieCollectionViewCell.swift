//
//  TodayMovieCollectionViewCell.swift
//  Moviegram
//
//  Created by 이빈 on 1/27/25.
//

import UIKit
import Kingfisher
import SnapKit

final class TodayMovieCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "TodayMovieCollectionViewCell"
    
    let moviePosterImage = UIImageView()
    
    let movieTitleLabel = UILabel()
    let movieLikeButton = UIButton()
    
    let movieOverviewLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        movieLikeButton.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    override func configureHierarchy() {
        addSubViews(
            moviePosterImage,
            movieTitleLabel,
            movieLikeButton,
            movieOverviewLabel
        )
    }
    
    override func configureLayout() {
        moviePosterImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(300)
        }
        
        movieTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(moviePosterImage.snp.bottom).offset(8)
            make.leading.equalToSuperview()
        }
        
        movieLikeButton.snp.makeConstraints { make in
            make.top.equalTo(moviePosterImage.snp.bottom).offset(8)
            make.leading.greaterThanOrEqualTo(movieTitleLabel.snp.trailing).offset(5)
            make.trailing.equalToSuperview()
        }
        
        movieOverviewLabel.snp.makeConstraints { make in
            make.top.equalTo(movieTitleLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview()
        }
        
    }
    
    override func configureView() {
        moviePosterImage.contentMode = .scaleAspectFill
        moviePosterImage.clipsToBounds = true
        moviePosterImage.layer.cornerRadius = 10
        moviePosterImage.tintColor = .point
        
        movieTitleLabel.font = .Font.large.of(weight: .heavy)
        movieTitleLabel.textColor = .white
        
        movieLikeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        movieLikeButton.tintColor = .point
        
        movieOverviewLabel.font = .Font.small.of(weight: .medium)
        movieOverviewLabel.textColor = .lightGray
        movieOverviewLabel.numberOfLines = 2
    }
    
    func configureData(data: Movie) {
        if let url = URL(string: TMDBAPI.imageBaseURL + data.posterURL) {
            moviePosterImage.kf.setImage(with: url)
        } else {
            moviePosterImage.image = UIImage(systemName: "exclamationmark.triangle")
        }
        
        movieTitleLabel.text = data.title
        
        movieOverviewLabel.text = data.overview
    }
    
}
