//
//  SearchTableViewCell.swift
//  Moviegram
//
//  Created by 이빈 on 1/28/25.
//

import UIKit
import Kingfisher
import SnapKit

final class SearchTableViewCell: BaseTableViewCell {
    
    static let identifier = "SearchTableViewCell"
    
    weak var delegate: LikeButtonDelegate?

    let movieImageView = UIImageView()
    let movieTitleLabel = UILabel()
    let movieReleaseLabel = UILabel()
    
    let genreBox1 = GenreBox()
    let genreBox2 = GenreBox()
    
    let movieLikeButton = LikeButton()
    
    override func configureHierarchy() {
        contentView.addSubViews(
            movieImageView,
            movieTitleLabel,
            movieReleaseLabel,
            genreBox1,
            genreBox2,
            movieLikeButton
        )
    }
    
    override func configureLayout() {
        movieImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(15)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(100)
            make.height.equalTo(120)
        }
        
        movieTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.equalTo(movieImageView.snp.trailing).offset(15)
        }
        
        movieReleaseLabel.snp.makeConstraints { make in
            make.top.equalTo(movieTitleLabel.snp.bottom).offset(5)
            make.leading.equalTo(movieImageView.snp.trailing).offset(15)
        }
        
        genreBox1.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(10)
            make.leading.equalTo(movieImageView.snp.trailing).offset(15)
        }
        
        genreBox2.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(10)
            make.leading.equalTo(genreBox1.snp.trailing).offset(5)
        }
        
        movieLikeButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(10)
        }
        
    }
    
    override func configureView() {
        
        backgroundColor = .black
        selectionStyle = .none
        
        movieImageView.contentMode = .scaleAspectFill
        movieImageView.clipsToBounds = true
        movieImageView.layer.cornerRadius = 10
        
        movieTitleLabel.font = .Font.large.of(weight: .bold)
        movieTitleLabel.textColor = .white
        movieTitleLabel.numberOfLines = 2
        
        movieReleaseLabel.font = .Font.medium.of(weight: .light)
        movieReleaseLabel.textColor = .customLightGray

        movieLikeButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped() {
        print(#function)
        movieLikeButton.isSelected.toggle()
        delegate?.likeButtonTapped(id: self.tag, isSelected: movieLikeButton.isSelected)
    }
    
    func configureData(data: Movie) {
        
        if let url = URL(string: TMDBAPI.imageBaseURL + data.posterURL) {
            movieImageView.kf.setImage(with: url)
        } else {
            movieImageView.image = UIImage(systemName: "exclamationmark.triangle")
        }
        
        movieTitleLabel.text = data.title
        movieReleaseLabel.text = data.releaseDate.convertDateString()
        
        if data.genreID.count >= 2 {
            genreBox1.genreTitleId = data.genreID[0]
            genreBox2.genreTitleId = data.genreID[1]
        } else if data.genreID.count == 1 {
            genreBox1.genreTitleId = data.genreID[0]
        }
        
        
        if UserInfo.storedMovieList.contains(data.id) {
            movieLikeButton.isSelected = true
        } else {
            movieLikeButton.isSelected = false
        }
        
    }
    
}
