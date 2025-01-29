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
        
        // 컬렉션뷰 딜리게이트
        mainView.backdropCollectionView.delegate = self
        mainView.backdropCollectionView.dataSource = self
        mainView.backdropCollectionView.register(BackdropCollectionViewCell.self, forCellWithReuseIdentifier: BackdropCollectionViewCell.identifier)
        
        // 영화 상세 정보 나타내기
        mainView.configureData(data: movieInfo)
        
    }

}

extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return backdropImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BackdropCollectionViewCell.identifier, for: indexPath) as! BackdropCollectionViewCell
        cell.configureData(url: backdropImages[indexPath.item].file_path)
        return cell
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
