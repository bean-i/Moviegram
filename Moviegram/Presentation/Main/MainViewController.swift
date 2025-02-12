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
    let viewModel = MainViewModel()
    
    // MARK: - 생명주기
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.output.viewWillAppearTrigger.value = ()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.input.viewDidLoadTrigger.value = ()
    }
    
    deinit {
        print("MainViewController Deinit")
    }
    
    override func bindData() {
        // viewWillAppear 데이터 업데이트 -> 로직 수정 필요.
        viewModel.output.viewWillAppearTrigger.lazyBind { [weak self] _ in
            self?.mainView.profileView.configureData(data: UserInfo.shared) // 프로필뷰 업데이트
            self?.mainView.todayMovieCollectionView.reloadData() // 오늘의 영화 컬렉션뷰 업데이트
            self?.viewModel.input.recentKeywords.value = UserInfo.shared.recentKeywords?.reversed() ?? [] // 최근 검색어 업데이트
            self?.mainView.recentKeywordCollectionView.reloadData()
        }
        
        // 오늘의 영화 (통신 성공 -> 컬렉션뷰 업데이트)
        viewModel.output.todayMovies.lazyBind { [weak self] _ in
            self?.mainView.todayMovieCollectionView.reloadData()
        }
        
        // alert (통신 실패 -> 오류 alert)
        viewModel.output.configureError.lazyBind { [weak self] error in
            guard let error else {
                print("error nil")
                return
            }
            self?.showErrorAlert(error: error)
        }
        
        // 최근 검색어 개수에 따른 컬렉션 뷰 or 레이블 보이기
        viewModel.output.recentKeywordView.lazyBind { [weak self] bool in
            print(bool)
            self?.mainView.recentKeywordCollectionView.isHidden = bool
            self?.mainView.noRecentSearchLabel.isHidden = !bool
        }
        
        // 네비게이션바 - 검색 버튼 탭
        viewModel.output.searchTapped.lazyBind { [weak self] _ in
            guard let self else {
                print("self 오류")
                return
            }
            
            let vc = SearchViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
        
        // 최근 검색 키워드 영역 - 버튼 탭
        viewModel.output.recentKeywordTapped.lazyBind { [weak self] index in
            guard let self,
                  let index else {
                print("self, index 오류")
                return
            }
            
            let vc = SearchViewController()
            vc.viewModel.input.recentKeywordTapped.value = viewModel.input.recentKeywords.value[index]
            navigationController?.pushViewController(vc, animated: true)
        }
        
        // 프로필뷰 탭 - 화면 전환
        viewModel.output.profileViewTapped.lazyBind { [weak self] _ in
            let vc = ProfileSettingViewController()
            vc.viewModel.input.editMode.value = true
            vc.viewModel.delegate = self
            let nav = UINavigationController(rootViewController: vc)
            
            nav.sheetPresentationController?.prefersGrabberVisible = true
            
            self?.present(nav, animated: true)
        }
        
        // 최근 검색어 테이블뷰 업데이트
        viewModel.output.recentKeywordsChanged.lazyBind { [weak self] _ in
            self?.mainView.recentKeywordCollectionView.reloadData()
        }
        
        // 영화 상세 화면 전환
        viewModel.output.movieTapped.lazyBind { [weak self] index in
            guard let self,
                  let index else {
                print("self, index 오류")
                return
            }
            let vc = MovieDetailViewController()
            vc.viewModel.input.movieInfo.value = viewModel.output.todayMovies.value[index]
            navigationController?.pushViewController(vc, animated: true)
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
    // "전체 삭제" 버튼 터치 시, userdefaults에 저장 된 정보 삭제
    @objc private func deleteAllSearchKeywordButtonTapped() {
        viewModel.input.deleteAllKeywordTapped.value = ()
    }
    
    // 네비게이션아이템의 검색 버튼 터치 시, 검색 화면으로 전환
    @objc private func searchButtonTapped() {
        viewModel.output.searchTapped.value = ()
    }
    
    // 프로필뷰 터치 시, 프로필설정화면 sheet present
    @objc private func profileViewTapped() {
        viewModel.output.profileViewTapped.value = ()
    }

}

// MARK: - Extension: CollectionView
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case mainView.recentKeywordCollectionView:
            return viewModel.input.recentKeywords.value.count
        case mainView.todayMovieCollectionView:
            return viewModel.output.todayMovies.value.count
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
            cell.configureData(text: viewModel.input.recentKeywords.value[indexPath.item])
            return cell
            
        case mainView.todayMovieCollectionView:
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayMovieCollectionViewCell.identifier, for: indexPath) as? TodayMovieCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.movieLikeButton.delegate = self
            cell.configureData(data: viewModel.output.todayMovies.value[indexPath.item])
            return cell
            
        default:
            return UICollectionViewCell()
        }
        
    }
    
    // 최근 검색 키워드 컬렉션뷰셀의 경우, 글자 크기를 기반으로 width 지정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView{
        case mainView.recentKeywordCollectionView:
            return CGSize(
                width: viewModel.getTextWidth(index: indexPath.item) + 40,
                height: 30
            )
            
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
            viewModel.output.recentKeywordTapped.value = indexPath.item
            
        case mainView.todayMovieCollectionView:
            // 영화 상세 화면 전환
            viewModel.output.movieTapped.value = indexPath.item

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
        viewModel.input.deleteKeywordTapped.value = index
    }
}
