//
//  MovieDetailView.swift
//  Moviegram
//
//  Created by 이빈 on 1/27/25.
//

import UIKit
import SnapKit

// MARK: - 영화 상세 View
final class MovieDetailView: BaseView {

    // MARK: - Properties
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    let backdropCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let pageControl = UIPageControl()
    
    private let movieInfoStackView = UIStackView()
    private let releaseView = MovieInfoView()
    private let rateView = MovieInfoView()
    private let genreView = MovieInfoView()
    
    private let synopsisLabel = UILabel()
    private let seeMoreButton = UIButton()
    private let synopsisDetailLabel = UILabel()
    
    private let castLabel = UILabel()
    let castCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    private let posterLabel = UILabel()
    let posterCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    // MARK: - LayoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        let line = synopsisDetailLabel.calculateNumberOfLines()
        if line > 4 {
            seeMoreButton.isHidden = false
        } else {
            seeMoreButton.isHidden = true
        }
    }
    
    // MARK: - Configure UI
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
            pageControl,
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
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(backdropCollectionView.snp.bottom).offset(-10)
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
        scrollView.showsVerticalScrollIndicator = false
        
        backdropCollectionView.collectionViewLayout = backdropCollectionViewLayout()
        backdropCollectionView.isPagingEnabled = true
        backdropCollectionView.backgroundColor = .black
        backdropCollectionView.showsHorizontalScrollIndicator = false
        
        pageControl.hidesForSinglePage = true
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .customGray
        pageControl.backgroundColor = .darkGray
        pageControl.layer.cornerRadius = 13
        
        movieInfoStackView.axis = .horizontal
        movieInfoStackView.alignment = .center
        movieInfoStackView.spacing = 10
        
        synopsisLabel.text = "Synopsis"
        synopsisLabel.textColor = .white
        synopsisLabel.font = .Font.large.of(weight: .bold)
        synopsisDetailLabel.numberOfLines = 3
        
        synopsisDetailLabel.textColor = .white
        synopsisDetailLabel.font = .Font.medium.of(weight: .medium)
        synopsisDetailLabel.lineBreakStrategy = .hangulWordPriority
        
        seeMoreButton.configuration = UIButton.Configuration.customStyle(title: "More")
        seeMoreButton.addTarget(self, action: #selector(seeMoreButtonTapped), for: .touchUpInside)
        seeMoreButton.isHidden = true
        
        castLabel.text = "Cast"
        castLabel.textColor = .white
        castLabel.font = .Font.large.of(weight: .bold)
        
        castCollectionView.collectionViewLayout = castCollectionViewLayout()
        castCollectionView.backgroundColor = .black
        castCollectionView.showsHorizontalScrollIndicator = false
        
        posterLabel.text = "Poster"
        posterLabel.textColor = .white
        posterLabel.font = .Font.large.of(weight: .bold)
        
        posterCollectionView.collectionViewLayout = posterCollectionViewLayout()
        posterCollectionView.backgroundColor = .black
        posterCollectionView.showsHorizontalScrollIndicator = false
        
    }
    
    // MARK: - Configure Data
    func configureData(data: MovieModel) {
        let date = data.releaseDate
        let rate = data.averageRating
        let genreID = (data.genreID != nil) ? data.genreID!.prefix(2) : []
        var genre = ""
        
        if genreID.count == 2 {
            genre = Genre.getGenre(id: genreID[0]) + ", " + Genre.getGenre(id: genreID[1])
        } else if genreID.count == 1 {
            genre = Genre.getGenre(id: genreID[0])
        }

        releaseView.configureData(image: "calendar", text: date ?? "")
        rateView.configureData(image: "star.fill", text: String(format: "%.1f", rate ?? 0))
        genreView.configureData(image: "film.fill", text: genre)

        synopsisDetailLabel.text = data.overview
    }
    
    // MARK: - CollectionView Layout
    private func backdropCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let deviceWidth = UIScreen.main.bounds.width
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: deviceWidth, height: 300)
        return layout
    }
    
    private func castCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: 200, height: 60)
        return layout
    }
    
    private func posterCollectionViewLayout() -> UICollectionViewLayout{
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: 120, height: 160)
        return layout
    }
    
    // MARK: - Methods
    private func convertSeeMoreButtonLabel(title: String) {
        var titleContainer = AttributeContainer()
        titleContainer.font = .Font.medium.of(weight: .bold)
        seeMoreButton.configuration?.attributedTitle = AttributedString(title, attributes: titleContainer)
    }
    
    @objc private func seeMoreButtonTapped() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            if self?.synopsisDetailLabel.numberOfLines == 0 {
                self?.convertSeeMoreButtonLabel(title: "More")
                self?.synopsisDetailLabel.numberOfLines = 3
            } else {
                self?.convertSeeMoreButtonLabel(title: "Hide")
                self?.synopsisDetailLabel.numberOfLines = 0
            }
            self?.layoutIfNeeded()
        }
    }

}
