//
//  MovieDetailView.swift
//  Moviegram
//
//  Created by 이빈 on 1/27/25.
//

import UIKit
import SnapKit

final class MovieDetailView: BaseView {

    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let backdropCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let movieInfoLabel = UILabel()
    
    let synopsisLabel = UILabel()
    let seeMoreButton = UIButton()
    let synopsisDetailLabel = UILabel()
    
    let castLabel = UILabel()
    
    
    override func configureHierarchy() {
        contentView.addSubViews(
            backdropCollectionView,
            movieInfoLabel,
            synopsisLabel,
            seeMoreButton,
            synopsisDetailLabel
        )
        
        scrollView.addSubview(contentView)
        
        addSubview(scrollView)
    }
    
    override func configureLayout() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        
        
        backdropCollectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(300)
        }
        
        movieInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(backdropCollectionView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        
        synopsisLabel.snp.makeConstraints { make in
            make.top.equalTo(movieInfoLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(10)
        }
        
        seeMoreButton.snp.makeConstraints { make in
            make.top.equalTo(movieInfoLabel.snp.bottom).offset(20)
            make.trailing.equalToSuperview().inset(10)
        }
        
        synopsisDetailLabel.snp.makeConstraints { make in
            make.top.equalTo(synopsisLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalToSuperview()
            make.bottom.equalTo(synopsisDetailLabel.snp.bottom)
        }
        
    }
    
    override func configureView() {
        backdropCollectionView.collectionViewLayout = backdropCollectionViewLayout()
        backdropCollectionView.isPagingEnabled = true
        backdropCollectionView.backgroundColor = .black
        
        movieInfoLabel.font = .Font.small.of(weight: .light)
        movieInfoLabel.textColor = .customLightGray
        
        synopsisLabel.text = "Synopsis"
        synopsisLabel.textColor = .white
        synopsisLabel.font = .Font.large.of(weight: .bold)
        
        synopsisDetailLabel.textColor = .white
        synopsisDetailLabel.font = .Font.medium.of(weight: .medium)
        synopsisDetailLabel.lineBreakStrategy = .hangulWordPriority
        
        var config = UIButton.Configuration.plain()
        var titleContainer = AttributeContainer()
        titleContainer.font = .Font.medium.of(weight: .bold)
        config.attributedTitle = AttributedString("More", attributes: titleContainer)
        config.baseForegroundColor = .point
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        seeMoreButton.configuration = config
        seeMoreButton.addTarget(self, action: #selector(seeMoreButtonTapped), for: .touchUpInside)
        
    }
    
    func configureData(data: Movie) {
        let date = data.releaseDate
        let rate = data.averageRating
        let genreID = data.genreID.prefix(2)
        movieInfoLabel.text = "\(date) \(rate)  \(genreID)"
        
        synopsisDetailLabel.text = data.overview
        synopsisDetailLabel.numberOfLines = 3
    }
    
    @objc func seeMoreButtonTapped() {
        if synopsisDetailLabel.numberOfLines == 0 {
            synopsisDetailLabel.numberOfLines = 3
        } else {
            synopsisDetailLabel.numberOfLines = 0
        }
        
    }
    
    
    func backdropCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let deviceWidth = UIScreen.main.bounds.width
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: deviceWidth, height: 300)
        return layout
    }

}
