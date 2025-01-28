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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainView.configureData(data: UserInfo.shared)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 오늘의 영화 데이터 불러오기
        NetworkManager.shared.getMovieData(api: .TodayMovie,
                                           type: TodayMovieData.self) { value in
            self.todayMovies = value.results
        }
        
        // delegate 설정
        mainView.todayMovieCollectionView.delegate = self
        mainView.todayMovieCollectionView.dataSource = self
        mainView.todayMovieCollectionView.register(TodayMovieCollectionViewCell.self, forCellWithReuseIdentifier: TodayMovieCollectionViewCell.identifier)
        
        // 프로필 뷰에 유저 이미지 보여주기
        mainView.configureData(data: UserInfo.shared)
    
        mainView.profileView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileViewTapped)))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: #selector(searchButtonTapped)
        )
        navigationItem.title = "Moviegram"
    }
    
    @objc func searchButtonTapped() {
        // 검색 화면 전환
        print(#function)
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
        mainView.configureData(data: UserInfo.shared)
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todayMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayMovieCollectionViewCell.identifier, for: indexPath) as! TodayMovieCollectionViewCell
        
        // 영화 데이터 표시
        cell.delegate = self
        cell.tag = todayMovies[indexPath.item].id // 영화 id를 tag로 설정
        cell.configureData(data: todayMovies[indexPath.item])
        
        return cell
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
        mainView.configureData(data: UserInfo.shared)
    }
    
}
