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
    
    weak var delegate: LikeButtonDelegate?
    
    let moviePosterImage = UIImageView()
    
    let movieTitleLabel = UILabel()
    let movieLikeButton = LikeButton()
    
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
        
        movieLikeButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
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
        
        // 현재 셀의 영화 id가 좋아요 영화 리스트에 저장되어 있으면 isSelected
        if UserInfo.storedMovieList.contains(data.id) {
            movieLikeButton.isSelected = true
        } else {
            movieLikeButton.isSelected = false
        }
        
        movieTitleLabel.text = data.title
        movieOverviewLabel.text = data.overview
    }
    
    @objc func buttonTapped() {
        movieLikeButton.isSelected.toggle()
        delegate?.likeButtonTapped(id: self.tag, isSelected: movieLikeButton.isSelected)
    }
    
}

