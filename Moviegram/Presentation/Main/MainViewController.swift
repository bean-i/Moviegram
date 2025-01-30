//
//  MainViewController.swift
//  Moviegram
//
//  Created by 이빈 on 1/25/25.
//

import UIKit

protocol passUserInfoDelegate: AnyObject {
    func passUserInfo()
}

final class MainViewController: BaseViewController<MainView> {
    
    // 오늘의 영화에 들어갈 데이터
    var todayMovies: [Movie] = [] {
        didSet {
            mainView.todayMovieCollectionView.reloadData()
        }
    }
    
    // 최근 검색 키워드
    var recentKeywords: [String] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 프로필 뷰에 유저 이미지 보여주기
        mainView.profileView.configureData(data: UserInfo.shared)
        mainView.todayMovieCollectionView.reloadData()
        // 최근 검색어 업데이트
        recentKeywords = UserInfo.shared.recentKeywords?.reversed() ?? []
        mainView.recentKeywordCollectionView.reloadData()
        
        // 최근 검색어 있으면, 컬렉션뷰 보여주고, 없으면 레이블 보여주기
        updateRecentKeywordView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 오늘의 영화 데이터 불러오기
        NetworkManager.shared.getMovieData(api: .TodayMovie,
                                           type: TodayMovieData.self) { value in
            self.todayMovies = value.results
        }
        
        // delegate 설정
        // 1) 오늘의 영화
        mainView.todayMovieCollectionView.delegate = self
        mainView.todayMovieCollectionView.dataSource = self
        mainView.todayMovieCollectionView.register(TodayMovieCollectionViewCell.self, forCellWithReuseIdentifier: TodayMovieCollectionViewCell.identifier)
    
        // 2) 최근 검색어
        mainView.recentKeywordCollectionView.delegate = self
        mainView.recentKeywordCollectionView.dataSource = self
        mainView.recentKeywordCollectionView.register(RecentKeywordCollectionViewCell.self, forCellWithReuseIdentifier: RecentKeywordCollectionViewCell.identifier)
        
        // 프로필뷰 터치 시, 모달 띄우기
        mainView.profileView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileViewTapped)))
        
        // 전체삭제 버튼 터치 시, 최근 검색어 내역 리셋
        mainView.deleteAllSearchKeywordButton.addTarget(self, action: #selector(deleteAllSearchKeywordButtonTapped), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: #selector(searchButtonTapped)
        )
        navigationItem.title = "Moviegram"
    }
    
    func updateRecentKeywordView() {
        if recentKeywords.count > 0 {
            mainView.recentKeywordCollectionView.isHidden = false
            mainView.noRecentSearchLabel.isHidden = true
        } else {
            mainView.recentKeywordCollectionView.isHidden = true
            mainView.noRecentSearchLabel.isHidden = false
        }
    }
    
    @objc func deleteAllSearchKeywordButtonTapped() {
        // userdefaults에 저장 된 정보 삭제
        UserDefaults.standard.removeObject(forKey: UserInfoKey.recentKeywordsKey.rawValue)
        recentKeywords = []
        // ui 업데이트
        updateRecentKeywordView()
    }
    
    @objc func searchButtonTapped() {
        // 검색 화면 전환
        let vc = SearchViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func profileViewTapped() {
        let vc = ProfileSettingViewController()
        vc.isEditMode = true
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        
        nav.sheetPresentationController?.prefersGrabberVisible = true
        
        present(nav, animated: true)
    }

}

extension MainViewController: passUserInfoDelegate {
    func passUserInfo() {
        mainView.profileView.configureData(data: UserInfo.shared)
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case mainView.recentKeywordCollectionView:
            return recentKeywords.count
        case mainView.todayMovieCollectionView:
            return todayMovies.count
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch collectionView {
        case mainView.recentKeywordCollectionView:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentKeywordCollectionViewCell.identifier, for: indexPath) as! RecentKeywordCollectionViewCell
            cell.keywordLabel.text = recentKeywords[indexPath.item]
            return cell
            
        case mainView.todayMovieCollectionView:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayMovieCollectionViewCell.identifier, for: indexPath) as! TodayMovieCollectionViewCell
            cell.movieLikeButton.delegate = self
            cell.configureData(data: todayMovies[indexPath.item])
            return cell
            
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView{
        case mainView.recentKeywordCollectionView:
            let text = recentKeywords[indexPath.item]
            let attributes = [NSAttributedString.Key.font: UIFont.Font.medium.of(weight: .medium)]
            let textSize = (text as NSString).size(withAttributes: attributes as [NSAttributedString.Key: Any])
            return CGSize(width: textSize.width + 40, height: 30)
            
        case mainView.todayMovieCollectionView:
            return CGSize(width: 210, height: 380)
            
        default:
            return .zero
        }
 
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 영화 상세 화면 전환
        let vc = MovieDetailViewController()
        vc.movieInfo = todayMovies[indexPath.item]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension MainViewController: LikeButtonDelegate {
    
    func likeButtonTapped(id: Int, isSelected: Bool) {
        print(#function, id, isSelected)
        if isSelected { // true이면 저장
            UserInfo.shared.storedMovies = [id]
        } else { // false이면 삭제
            if let index = UserInfo.storedMovieList.firstIndex(of: id) {
                UserInfo.storedMovieList.remove(at: index)
                UserInfo.shared.storedMovies = Array(UserInfo.storedMovieList) // 새로운 집합으로 업데이트
            }
        }
        // 버튼 업데이트 시, 프로필 뷰 업데이트!
        mainView.profileView.configureData(data: UserInfo.shared)
    }
    
}
