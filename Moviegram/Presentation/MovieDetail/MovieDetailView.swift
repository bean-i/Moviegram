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
    let castCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    
    override func configureHierarchy() {
        contentView.addSubViews(
            backdropCollectionView,
            movieInfoLabel,
            synopsisLabel,
            seeMoreButton,
            synopsisDetailLabel,
            castLabel,
            castCollectionView
        )
        
        scrollView.addSubview(contentView)
        
        addSubview(scrollView)
    }
    
    override func configureLayout() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalToSuperview()
            make.bottom.equalTo(castCollectionView.snp.bottom)
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
        
        castLabel.snp.makeConstraints { make in
            make.top.equalTo(synopsisDetailLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(10)
        }
        
        castCollectionView.snp.makeConstraints { make in
            make.top.equalTo(castLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(135)
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
        
        castLabel.text = "Cast"
        castLabel.textColor = .white
        castLabel.font = .Font.large.of(weight: .bold)
        
        castCollectionView.collectionViewLayout = castCollectionViewLayout()
        castCollectionView.backgroundColor = .black
        
    }
    
    func configureData(data: Movie) {
        let date = data.releaseDate
        let rate = data.averageRating
        let genreID = data.genreID.prefix(2)
        movieInfoLabel.text = "\(date) \(rate)  \(genreID)"
        
        synopsisDetailLabel.text = data.overview
        synopsisDetailLabel.numberOfLines = 3
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
    
    func castCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: 200, height: 60)
        return layout
    }
    
    @objc func seeMoreButtonTapped() {
        if synopsisDetailLabel.numberOfLines == 0 {
            synopsisDetailLabel.numberOfLines = 3
        } else {
            synopsisDetailLabel.numberOfLines = 0
        }
    }

}
