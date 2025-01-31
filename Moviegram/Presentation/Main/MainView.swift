//
//  MainView.swift
//  Moviegram
//
//  Created by 이빈 on 1/26/25.
//

import UIKit
import SnapKit

final class MainView: BaseView {
    
    let profileView = ProfileView()
    
    private let recentSearchLabel = UILabel()
    let deleteAllSearchKeywordButton = UIButton()
    private let recentSearchKeywordView = UIView()
    let noRecentSearchLabel = UILabel()
    let recentKeywordCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    private let todayMovieLabel = UILabel()
    let todayMovieCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    override func configureHierarchy() {
        recentSearchKeywordView.addSubViews(
            noRecentSearchLabel,
            recentKeywordCollectionView
        )
        
        addSubViews(
            profileView,
            recentSearchLabel,
            deleteAllSearchKeywordButton,
            recentSearchKeywordView,
            todayMovieLabel,
            todayMovieCollectionView
        )
    }

    override func configureLayout() {
        profileView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        
        recentSearchLabel.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(10)
        }
        
        deleteAllSearchKeywordButton.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(20)
            make.trailing.equalToSuperview().inset(10)
        }
        
        recentSearchKeywordView.snp.makeConstraints { make in
            make.top.equalTo(recentSearchLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        noRecentSearchLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        recentKeywordCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        todayMovieLabel.snp.makeConstraints { make in
            make.top.equalTo(recentSearchKeywordView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(10)
        }
        
        todayMovieCollectionView.snp.makeConstraints { make in
            make.top.equalTo(todayMovieLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(380)
            
        }
        
    }
    
    override func configureView() {
        
        recentSearchLabel.text = "최근검색어"
        recentSearchLabel.textColor = .white
        recentSearchLabel.font = .Font.large.of(weight: .heavy)
        
        deleteAllSearchKeywordButton.configuration = UIButton.Configuration.customStyle(title: "전체 삭제")
        
        noRecentSearchLabel.isHidden = true
        noRecentSearchLabel.text = "최근 검색어 내역이 없습니다."
        noRecentSearchLabel.textColor = .gray
        noRecentSearchLabel.font = .Font.small.of(weight: .medium)
        
        recentKeywordCollectionView.collectionViewLayout = recentKeywordCollectionViewLayout()
        recentKeywordCollectionView.backgroundColor = .black
        
        todayMovieLabel.text = "오늘의 영화"
        todayMovieLabel.textColor = .white
        todayMovieLabel.font = .Font.large.of(weight: .heavy)
        
        todayMovieCollectionView.collectionViewLayout = todayMovieCollectionViewLayout()
        todayMovieCollectionView.showsHorizontalScrollIndicator = false
        todayMovieCollectionView.backgroundColor = .black
    }
    
    private func todayMovieCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 10
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        layout.minimumInteritemSpacing = spacing
        layout.itemSize = CGSize(width: 210, height: 380)
        return layout
    }
    
    private func recentKeywordCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return layout
    }
    
}
