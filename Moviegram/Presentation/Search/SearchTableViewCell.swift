//
//  SearchTableViewCell.swift
//  Moviegram
//
//  Created by 이빈 on 1/28/25.
//

import UIKit

import Kingfisher
import SnapKit

// MARK: - 검색 TableViewCell
final class SearchTableViewCell: BaseTableViewCell {
    
    // MARK: - Properties
    static let identifier = "SearchTableViewCell"

    private let movieImageView = UIImageView()
    private let movieTitleLabel = UILabel()
    private let movieReleaseLabel = UILabel()
    
    private let genreBox1 = GenreBox()
    private let genreBox2 = GenreBox()
    
    let movieLikeButton = LikeButton()
    
    // MARK: - Configure UI
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
            make.trailing.equalToSuperview().inset(10)
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
        movieImageView.tintColor = .customGray
        
        movieTitleLabel.font = .Font.large.of(weight: .bold)
        movieTitleLabel.textColor = .white
        movieTitleLabel.textAlignment = .left
        movieTitleLabel.numberOfLines = 2
        
        movieReleaseLabel.font = .Font.medium.of(weight: .light)
        movieReleaseLabel.textColor = .customLightGray
    }
    
    // MARK: - Configure Data
    func configureData(data: MovieModel) {
        
        if let posterURL = data.posterURL,
           let url = URL(string: TMDBAPI.imageBaseURL + posterURL) {
            movieImageView.kf.setImage(with: url)
        } else {
            movieImageView.contentMode = .scaleAspectFit
            movieImageView.image = UIImage(systemName: "exclamationmark.triangle")
        }
        
        movieTitleLabel.text = data.title
        movieReleaseLabel.text = data.releaseDate?.convertDateString()
        
        if let genreList = data.genreID {
            if genreList.count >= 2 {
                genreBox1.genreTitleId = genreList[0]
                genreBox2.genreTitleId = genreList[1]
            } else if genreList.count == 1 {
                genreBox1.genreTitleId = genreList[0]
                genreBox2.isHidden = true
            } else {
                genreBox1.isHidden = true
                genreBox2.isHidden = true
            }
        }
        
        movieLikeButton.id = data.id
        
        if UserInfo.storedMovieList.contains(data.id) {
            movieLikeButton.isSelected = true
        } else {
            movieLikeButton.isSelected = false
        }
        
    }
    
}
