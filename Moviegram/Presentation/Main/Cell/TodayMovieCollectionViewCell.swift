//
//  TodayMovieCollectionViewCell.swift
//  Moviegram
//
//  Created by 이빈 on 1/27/25.
//

import UIKit

import Kingfisher
import SnapKit

// MARK: - 오늘의 영화 CollectionViewCell
final class TodayMovieCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Properties
    static let identifier = "TodayMovieCollectionViewCell"
    
    private let moviePosterImage = UIImageView()
    
    private let movieTitleLabel = UILabel()
    let movieLikeButton = LikeButton()
    
    private let movieOverviewLabel = UILabel()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        movieLikeButton.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    // MARK: - Configure UI
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
        
        movieOverviewLabel.font = .Font.small.of(weight: .medium)
        movieOverviewLabel.textColor = .lightGray
        movieOverviewLabel.numberOfLines = 2
    }
    
    // MARK: - Configure Data
    func configureData(data: Movie) {

        if let posterURL = data.posterURL,
           let url = URL(string: TMDBAPI.imageBaseURL + posterURL) {
            moviePosterImage.kf.setImage(with: url)
        } else {
            moviePosterImage.image = UIImage(systemName: "exclamationmark.triangle")
        }
        
        movieLikeButton.id = data.id
        
        // 현재 셀의 영화 id가 좋아요 영화 리스트에 저장되어 있으면 isSelected
        if UserInfo.storedMovieList.contains(data.id) {
            movieLikeButton.isSelected = true
        } else {
            movieLikeButton.isSelected = false
        }
        
        movieTitleLabel.text = data.title
        movieOverviewLabel.text = data.overview
    }
    
}

