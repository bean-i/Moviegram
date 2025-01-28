//
//  MainView.swift
//  Moviegram
//
//  Created by 이빈 on 1/26/25.
//

import UIKit
import SnapKit

final class MainView: BaseView {
    
    let profileView = UIView()
    let profileImageView = ProfileImageCustomView()
    let profileNickNameLabel = UILabel()
    let joinDateLabel = UILabel()
    let chevronButton = UIImageView()
    let movieStorageButton = UIButton()
    
    let recentSearchLabel = UILabel()
    let deleteAllSearchKeywordButton = UIButton()
    let recentSearchKeywordView = UIView()
    let noRecentSearchLabel = UILabel()
    
    let todayMovieLabel = UILabel()
    let todayMovieCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())

    func todayMovieCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 10
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        layout.minimumInteritemSpacing = spacing
        layout.itemSize = CGSize(width: 210, height: 380)
        return layout
    }
    
    override func configureHierarchy() {
        profileView.addSubViews(
            profileImageView,
            profileNickNameLabel,
            joinDateLabel,
            chevronButton,
            movieStorageButton
        )
        
        recentSearchKeywordView.addSubViews(
            noRecentSearchLabel
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
        
        profileImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(15)
            make.size.equalTo(60)
        }
        
        profileNickNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(25)
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
        }
        
        joinDateLabel.snp.makeConstraints { make in
            make.top.equalTo(profileNickNameLabel.snp.bottom).offset(3)
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
        }
        
        chevronButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(15)
            make.width.equalTo(15)
            make.height.equalTo(25)
        }
        
        movieStorageButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.bottom.equalToSuperview().inset(15)
            make.horizontalEdges.equalToSuperview().inset(15)
            make.height.equalTo(40)
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
        profileView.isUserInteractionEnabled = true
        profileView.backgroundColor = .customDarkGray
        profileView.layer.cornerRadius = 15

        profileImageView.isSelected = true
        
        profileNickNameLabel.font = .Font.large.of(weight: .heavy)
        profileNickNameLabel.textColor = .white
        
        joinDateLabel.font = .Font.small.of(weight: .medium)
        joinDateLabel.textColor = .gray
        
        chevronButton.image = UIImage(systemName: "chevron.right")
        chevronButton.tintColor = .gray
        
        movieStorageButton.backgroundColor = .customTeal
        movieStorageButton.layer.cornerRadius = 10
        movieStorageButton.tintColor = .white
        movieStorageButton.titleLabel?.font = .Font.medium.of(weight: .bold)
        
        recentSearchLabel.text = "최근검색어"
        recentSearchLabel.textColor = .white
        recentSearchLabel.font = .Font.large.of(weight: .heavy)
        
        var config = UIButton.Configuration.plain()
        var titleContainer = AttributeContainer()
        titleContainer.font = .Font.medium.of(weight: .bold)
        config.attributedTitle = AttributedString("전체 삭제", attributes: titleContainer)
        config.baseForegroundColor = .point
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        deleteAllSearchKeywordButton.configuration = config
        
        noRecentSearchLabel.text = "최근 검색어 내역이 없습니다."
        noRecentSearchLabel.textColor = .gray
        noRecentSearchLabel.font = .Font.small.of(weight: .medium)
        
        todayMovieLabel.text = "오늘의 영화"
        todayMovieLabel.textColor = .white
        todayMovieLabel.font = .Font.large.of(weight: .heavy)
        
        todayMovieCollectionView.collectionViewLayout = todayMovieCollectionViewLayout()
        todayMovieCollectionView.showsHorizontalScrollIndicator = false
        todayMovieCollectionView.backgroundColor = .black
    }
    
    func configureData(data: UserInfo) {
        guard let nickname = data.nickname,
              let imageNumber = data.imageNumber,
              let joinDate = data.joinDate,
              let storedMovies = data.storedMovies else {
            print("유저 인포 오류") // 얼럿 띄워줘야하나. . .?
            return
        }
        
        profileImageView.imageNumber = imageNumber
        profileNickNameLabel.text = nickname
        joinDateLabel.text = "\(joinDate) 가입"
        movieStorageButton.setTitle("\(storedMovies.count)개의 무비박스 보관중", for: .normal)
    }
    
}
