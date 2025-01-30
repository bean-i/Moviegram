//
//  MovieDetailViewController.swift
//  Moviegram
//
//  Created by 이빈 on 1/27/25.
//

import UIKit

final class MovieDetailViewController: BaseViewController<MovieDetailView> {

    var movieInfo: Movie?

    let likeButton = LikeButton()
    
    var backdropImages: [ImagePath] = []
    var castInfos: [Cast] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let id = likeButton.id {
            if UserInfo.storedMovieList.contains(id) {
                likeButton.isSelected = true
            } else {
                likeButton.isSelected = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let movieInfo else {
            print("잘못된 접근")
            return
        }
        
        // 네비게이션바 좋아요 버튼
        likeButton.id = movieInfo.id
        likeButton.delegate = self
        
        // 타이틀, 하트
        title = movieInfo.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: likeButton)
        
        // 백드롭 이미지 네트워크
        NetworkManager.shared.getMovieData(api: .MovieImage(id: movieInfo.id), type: MovieImageData.self) { value in
            // 백드롭 이미지 5개까지만 넣기
            self.backdropImages = Array(value.backdrops.prefix(5))
            self.mainView.backdropCollectionView.reloadData()
        }
        
        // 캐스트 네트워크
        NetworkManager.shared.getMovieData(api: .Cast(id: movieInfo.id), type: CreditData.self) { value in
            print(value)
            self.castInfos = value.cast
            self.mainView.castCollectionView.reloadData()
        }
        
        
        // 컬렉션뷰 딜리게이트
        // 1) 백드롭 컬렉션뷰
        mainView.backdropCollectionView.delegate = self
        mainView.backdropCollectionView.dataSource = self
        mainView.backdropCollectionView.register(BackdropCollectionViewCell.self, forCellWithReuseIdentifier: BackdropCollectionViewCell.identifier)
        
        // 2) 캐스트 컬렉션뷰
        mainView.castCollectionView.delegate = self
        mainView.castCollectionView.dataSource = self
        mainView.castCollectionView.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: CastCollectionViewCell.identifier)
        
        // 영화 상세 정보 나타내기
        mainView.configureData(data: movieInfo)
        
    }

}

extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    // 한 화면에 3개의 컬렉션뷰
    // 컬렉션뷰마다 분기처리 해주기
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case mainView.backdropCollectionView:
            return backdropImages.count
        case mainView.castCollectionView:
            return castInfos.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        switch collectionView {
        case mainView.backdropCollectionView:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BackdropCollectionViewCell.identifier, for: indexPath) as! BackdropCollectionViewCell
            cell.configureData(url: backdropImages[indexPath.item].file_path)
            return cell
            
        case mainView.castCollectionView:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.identifier, for: indexPath) as! CastCollectionViewCell
            cell.configureData(data: castInfos[indexPath.item])
            return cell
            
        default:
            return UICollectionViewCell()
        }
        
    
    }
    
    
}

extension MovieDetailViewController: LikeButtonDelegate {
    
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
    }

}
