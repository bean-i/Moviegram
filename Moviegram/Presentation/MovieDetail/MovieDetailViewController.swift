//
//  MovieDetailViewController.swift
//  Moviegram
//
//  Created by 이빈 on 1/27/25.
//

import UIKit

// MARK: - 영화 상세 ViewController
final class MovieDetailViewController: BaseViewController<MovieDetailView> {

    // MARK: - Properties
    var movieInfo: MovieModel?

    private let likeButton = LikeButton()
    
    private var backdropImages: [ImagePath] = []
    private var castInfos: [Cast] = []
    private var posterImages: [ImagePath] = []
    
    private let group = DispatchGroup()
    
    // MARK: - 생명주기
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
    
    // MARK: - Configure
    override func configureView() {
        
        guard let movieInfo else {
            showAlert(
                title: "잘못된 접근",
                message: "잘못된 접근입니다. 다시 접근해 주세요.",
                cancel: false) {
                    self.navigationController?.popViewController(animated: true)
                }
            return
        }
        
        title = movieInfo.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: likeButton)
        
        // 네비게이션바 좋아요 버튼
        likeButton.id = movieInfo.id
        likeButton.delegate = self
        
        // 영화 상세 정보 나타내기
        mainView.configureData(data: movieInfo)
        
        group.enter()
        // 백드롭 + 포스터 이미지 네트워크
        NetworkManager.shared.getMovieData(api: .MovieImage(id: movieInfo.id), type: MovieImageModel.self) { value in
            // 백드롭 이미지 5개까지만 넣기
            self.backdropImages = Array(value.backdrops.prefix(5))
            // pagecontrol 개수 지정
            self.mainView.pageControl.numberOfPages = self.backdropImages.count
            // 포스터 이미지
            self.posterImages = value.posters
            self.group.leave()
        } failHandler: { statusCode in
            self.group.leave()
            self.showErrorAlert(error: statusCode)
        }
        
        group.enter()
        // 캐스트 네트워크
        NetworkManager.shared.getMovieData(api: .Cast(id: movieInfo.id), type: CreditModel.self) { value in
            self.castInfos = value.cast
            self.group.leave()
        } failHandler: { statusCode in
            self.group.leave()
            self.showErrorAlert(error: statusCode)
        }
        
        group.notify(queue: .main) {
            self.mainView.backdropCollectionView.reloadData()
            self.mainView.castCollectionView.reloadData()
            self.mainView.posterCollectionView.reloadData()
        }
    }
    
    override func configureDelegate() {
        // 1) 백드롭 컬렉션뷰
        mainView.backdropCollectionView.delegate = self
        mainView.backdropCollectionView.dataSource = self
        mainView.backdropCollectionView.register(BackdropCollectionViewCell.self, forCellWithReuseIdentifier: BackdropCollectionViewCell.identifier)
        
        // 2) 캐스트 컬렉션뷰
        mainView.castCollectionView.delegate = self
        mainView.castCollectionView.dataSource = self
        mainView.castCollectionView.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: CastCollectionViewCell.identifier)
        
        // 3) 포스터 컬렉션뷰
        mainView.posterCollectionView.delegate = self
        mainView.posterCollectionView.dataSource = self
        mainView.posterCollectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
    }

}

// MARK: - Extension: CollectionView
extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case mainView.backdropCollectionView:
            return backdropImages.count
        case mainView.castCollectionView:
            return castInfos.count
        case mainView.posterCollectionView:
            return posterImages.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case mainView.backdropCollectionView:
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BackdropCollectionViewCell.identifier, for: indexPath) as? BackdropCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configureData(url: backdropImages[indexPath.item].file_path)
            return cell
            
        case mainView.castCollectionView:
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.identifier, for: indexPath) as? CastCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configureData(data: castInfos[indexPath.item])
            return cell
            
        case mainView.posterCollectionView:
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as? PosterCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configureData(url: posterImages[indexPath.item].file_path)
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == mainView.backdropCollectionView {
            let deviceWidth = UIScreen.main.bounds.width
            let page = Int(targetContentOffset.pointee.x / deviceWidth)
            mainView.pageControl.currentPage = page
        }
    }
    
}
