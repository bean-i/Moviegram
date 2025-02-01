//
//  MainViewController.swift
//  Moviegram
//
//  Created by 이빈 on 1/25/25.
//

import UIKit

// MARK: - 메인 ViewController
final class MainViewController: BaseViewController<MainView> {
    
    // MARK: - Properties
    // 오늘의 영화 데이터
    private var todayMovies: [MovieModel] = [] {
        didSet {
            mainView.todayMovieCollectionView.reloadData()
        }
    }
    
    // 최근 검색 키워드
    private var recentKeywords: [String] = []
    
    // MARK: - 생명주기
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mainView.profileView.configureData(data: UserInfo.shared) // 프로필뷰 업데이트
        mainView.todayMovieCollectionView.reloadData() // 오늘의 영화 컬렉션뷰 업데이트
        recentKeywords = UserInfo.shared.recentKeywords?.reversed() ?? [] // 최근 검색어 업데이트
        mainView.recentKeywordCollectionView.reloadData()
        
        // 최근 검색어 있으면, 컬렉션뷰 보여주고, 없으면 레이블 보여주기
        updateRecentKeywordView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 오늘의 영화 데이터 불러오기
        NetworkManager.shared.getMovieData(api: .TodayMovie,
                                           type: TodayMovieModel.self) { value in
            self.todayMovies = value.results
        } failHandler: { statusCode in
            self.showErrorAlert(error: statusCode)
        }

    }
    
    // MARK: - Configure
    override func configureView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: #selector(searchButtonTapped)
        )
        navigationItem.title = "Moviegram"
    }
    
    override func configureDelegate() {
        // 1) 오늘의 영화
        mainView.todayMovieCollectionView.delegate = self
        mainView.todayMovieCollectionView.dataSource = self
        mainView.todayMovieCollectionView.register(TodayMovieCollectionViewCell.self, forCellWithReuseIdentifier: TodayMovieCollectionViewCell.identifier)
    
        // 2) 최근 검색어
        mainView.recentKeywordCollectionView.delegate = self
        mainView.recentKeywordCollectionView.dataSource = self
        mainView.recentKeywordCollectionView.register(RecentKeywordCollectionViewCell.self, forCellWithReuseIdentifier: RecentKeywordCollectionViewCell.identifier)
    }
    
    override func configureGesture() {
        // 프로필뷰 터치 시, 모달 띄우기
        mainView.profileView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileViewTapped)))
        
        // 전체삭제 버튼 터치 시, 최근 검색어 내역 리셋
        mainView.deleteAllSearchKeywordButton.addTarget(self, action: #selector(deleteAllSearchKeywordButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Methods
    // 최근 검색어 개수에 따라, 컬렉션뷰 or 레이블 보여주기
    private func updateRecentKeywordView() {
        if recentKeywords.count > 0 {
            mainView.recentKeywordCollectionView.isHidden = false
            mainView.noRecentSearchLabel.isHidden = true
        } else {
            mainView.recentKeywordCollectionView.isHidden = true
            mainView.noRecentSearchLabel.isHidden = false
        }
    }
    
    // "전체 삭제" 버튼 터치 시, userdefaults에 저장 된 정보 삭제
    @objc private func deleteAllSearchKeywordButtonTapped() {
        UserDefaults.standard.removeObject(forKey: UserInfoKey.recentKeywordsKey.rawValue)
        recentKeywords = []
        // UI 업데이트
        updateRecentKeywordView()
    }
    
    // 네비게이션아이템의 검색 버튼 터치 시, 검색 화면으로 전환
    @objc private func searchButtonTapped() {
        let vc = SearchViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 프로필뷰 터치 시, 프로필설정화면 sheet present
    @objc private func profileViewTapped() {
        let vc = ProfileSettingViewController()
        vc.isEditMode = true
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        
        nav.sheetPresentationController?.prefersGrabberVisible = true
        
        present(nav, animated: true)
    }

}

// MARK: - Extension: CollectionView
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
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentKeywordCollectionViewCell.identifier, for: indexPath) as? RecentKeywordCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            cell.index = indexPath.item
            cell.configureData(text: recentKeywords[indexPath.item])
            return cell
            
        case mainView.todayMovieCollectionView:
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayMovieCollectionViewCell.identifier, for: indexPath) as? TodayMovieCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.movieLikeButton.delegate = self
            cell.configureData(data: todayMovies[indexPath.item])
            return cell
            
        default:
            return UICollectionViewCell()
        }
        
    }
    
    // 최근 검색 키워드 컬렉션뷰셀의 경우, 글자 크기를 기반으로 width 지정
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
        
        switch collectionView {
        case mainView.recentKeywordCollectionView:
            // 검색 결과 화면 전환
            let vc = SearchViewController()
            vc.currentKeyword = recentKeywords[indexPath.item]
            vc.mainView.searchBar.text = recentKeywords[indexPath.item]
            vc.mainView.searchBar.resignFirstResponder() // 키워드 터치 -> 상세화면 전환될 때, 키보드 올리지 않기
            vc.getData()
            navigationController?.pushViewController(vc, animated: true)
            
        case mainView.todayMovieCollectionView:
            // 영화 상세 화면 전환
            let vc = MovieDetailViewController()
            vc.movieInfo = todayMovies[indexPath.item]
            navigationController?.pushViewController(vc, animated: true)
        
        default:
            return
        }

    }
    
}

// MARK: - Extension: Delegate
// 유저 정보 전달 delegate 채택
extension MainViewController: PassUserInfoDelegate {
    func passUserInfo() {
        mainView.profileView.configureData(data: UserInfo.shared)
    }
}

extension MainViewController: DeleteKeywordDelegate {
    func deleteKeyword(index: Int) { // 키워드 삭제
        var keywords = recentKeywords
        keywords.remove(at: index)
        UserDefaults.standard.set(keywords, forKey: UserInfoKey.recentKeywordsKey.rawValue)
        recentKeywords = UserInfo.shared.recentKeywords ?? []
        mainView.recentKeywordCollectionView.reloadData()
    }
}
