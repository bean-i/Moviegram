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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 오늘의 영화 데이터 불러오기
        NetworkManager.shared.getTodayMovies(api: .TodayMovie) { value in
            print(value)
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
        print(#function)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayMovieCollectionViewCell.identifier, for: indexPath) as! TodayMovieCollectionViewCell
        
        cell.configureData(data: todayMovies[indexPath.item])
        
        return cell
        
    }
    
    
}
