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
    
    let movieInfoStackView = UIStackView()
    let releaseView = MovieInfoView()
    let rateView = MovieInfoView()
    let genreView = MovieInfoView()
    
    let synopsisLabel = UILabel()
    let seeMoreButton = UIButton()
    let synopsisDetailLabel = UILabel()
    
    let castLabel = UILabel()
    let castCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    let posterLabel = UILabel()
    let posterCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    override func configureHierarchy() {
        
        movieInfoStackView.addArrangedSubviews(
            releaseView,
            DistributeView(),
            rateView,
            DistributeView(),
            genreView
        )
        
        contentView.addSubViews(
            backdropCollectionView,
            movieInfoStackView,
            synopsisLabel,
            seeMoreButton,
            synopsisDetailLabel,
            castLabel,
            castCollectionView,
            posterLabel,
            posterCollectionView
        )
        
        scrollView.addSubview(contentView)
        
        addSubview(scrollView)
    }
    
    override func configureLayout() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.verticalEdges.equalTo(scrollView)
            make.bottom.equalTo(posterCollectionView.snp.bottom).offset(10)
        }
        
        backdropCollectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(300)
        }
        
        movieInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(backdropCollectionView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        synopsisLabel.snp.makeConstraints { make in
            make.top.equalTo(movieInfoStackView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(10)
        }
        
        seeMoreButton.snp.makeConstraints { make in
            make.top.equalTo(movieInfoStackView.snp.bottom).offset(20)
            make.trailing.equalToSuperview().inset(10)
        }
        
        synopsisDetailLabel.snp.makeConstraints { make in
            make.top.equalTo(synopsisLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        castLabel.snp.makeConstraints { make in
            make.top.equalTo(synopsisDetailLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(10)
        }
        
        castCollectionView.snp.makeConstraints { make in
            make.top.equalTo(castLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(135)
        }
        
        posterLabel.snp.makeConstraints { make in
            make.top.equalTo(castCollectionView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(10)
        }
        
        posterCollectionView.snp.makeConstraints { make in
            make.top.equalTo(posterLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(160)
        }
    }
    
    override func configureView() {
        backdropCollectionView.collectionViewLayout = backdropCollectionViewLayout()
        backdropCollectionView.isPagingEnabled = true
        backdropCollectionView.backgroundColor = .black
        
        movieInfoStackView.axis = .horizontal
        movieInfoStackView.alignment = .center
        movieInfoStackView.spacing = 10
        
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
        
        posterLabel.text = "Poster"
        posterLabel.textColor = .white
        posterLabel.font = .Font.large.of(weight: .bold)
        
        posterCollectionView.collectionViewLayout = posterCollectionViewLayout()
        posterCollectionView.backgroundColor = .black
        
        
    }
    
    func configureData(data: Movie) {
        let date = data.releaseDate
        let rate = data.averageRating
        let genreID = data.genreID.prefix(2)
        var genre = ""
        
        if genreID.count == 2 {
            genre = Genre.getGenre(id: genreID[0]) + ", " + Genre.getGenre(id: genreID[1])
        } else if genreID.count == 1 {
            genre = Genre.getGenre(id: genreID[0])
        }

        releaseView.configureData(image: "calendar", text: date)
        rateView.configureData(image: "star.fill", text: String(rate))
        genreView.configureData(image: "film.fill", text: genre)
        
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
    
    func posterCollectionViewLayout() -> UICollectionViewLayout{
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: 120, height: 160)
        return layout
    }
    
    func convertSeeMoreButtonLabel(title: String) {
        var titleContainer = AttributeContainer()
        titleContainer.font = .Font.medium.of(weight: .bold)
        seeMoreButton.configuration?.attributedTitle = AttributedString(title, attributes: titleContainer)
    }
    
    @objc func seeMoreButtonTapped() {
        if synopsisDetailLabel.numberOfLines == 0 {
            convertSeeMoreButtonLabel(title: "More")
            synopsisDetailLabel.numberOfLines = 3
        } else {
            convertSeeMoreButtonLabel(title: "Hide")
            synopsisDetailLabel.numberOfLines = 0
        }
    }

}
