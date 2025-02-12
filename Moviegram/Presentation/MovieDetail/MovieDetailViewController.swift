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
    let viewModel = MovieDetailViewModel()
    
    // MARK: - init
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.input.viewWillAppearTrigger.value = ()
    }
    
    deinit {
        print("MovieDetailViewController Deinit")
    }
    
    override func bindData() {
        // 영화 데이터 전 화면에서 안 넘어온 경우 alert
        viewModel.output.showAlert.lazyBind { [weak self] _ in
            self?.showAlert(
                title: "잘못된 접근",
                message: "잘못된 접근입니다. 다시 접근해 주세요.",
                cancel: false) {
                    self?.navigationController?.popViewController(animated: true)
                }
        }
        
        // 네비게이션바 및 영화정보뷰 업데이트
        viewModel.output.configureView.lazyBind { [weak self] _ in
            guard let self,
                  let movieInfo = viewModel.input.movieInfo.value else {
                print("self/movieInfo 오류")
                return
            }
            
            // 네비게이션바
            title = movieInfo.title
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: viewModel.likeButton)
            
            // 네비게이션바 좋아요 버튼
            viewModel.likeButton.delegate = self
            
            // 영화 상세 정보 나타내기
            mainView.configureData(data: movieInfo)
        }
        
        // 백드롭 이미지
        viewModel.output.backdropImages.lazyBind { [weak self] _ in
            self?.mainView.pageControl.numberOfPages = self?.viewModel.output.backdropImages.value.count ?? 0
        }
        
        // alert (통신 실패 -> 오류 alert)
        viewModel.output.showErrorAlert.lazyBind { [weak self] error in
            guard let error else {
                print("error nil")
                return
            }
            self?.showErrorAlert(error: error)
        }
        
        // 통신 완료 -> reload
        viewModel.output.completeNetwork.lazyBind { [weak self] _ in
            self?.mainView.backdropCollectionView.reloadData()
            self?.mainView.castCollectionView.reloadData()
            self?.mainView.posterCollectionView.reloadData()
        }
        
    }
    
    // MARK: - Configure
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
            return viewModel.output.backdropImages.value.count
        case mainView.castCollectionView:
            return viewModel.castInfos.count
        case mainView.posterCollectionView:
            return viewModel.posterImages.count
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
            cell.configureData(url: viewModel.output.backdropImages.value[indexPath.item].file_path)
            return cell
            
        case mainView.castCollectionView:
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.identifier, for: indexPath) as? CastCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configureData(data: viewModel.castInfos[indexPath.item])
            return cell
            
        case mainView.posterCollectionView:
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as? PosterCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configureData(url: viewModel.posterImages[indexPath.item].file_path)
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
