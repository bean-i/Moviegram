//
//  MovieDetailViewModel.swift
//  Moviegram
//
//  Created by 이빈 on 2/12/25.
//

import Foundation

final class MovieDetailViewModel: BaseViewModel {
    
    struct Input {
        // 상세화면에서 보여줄 영화 정보
        let movieInfo: Observable<MovieModel?> = Observable(nil)
        // viewWillAppear -> likeButton UI
        let viewWillAppearTrigger: Observable<Void> = Observable(())
    }
    
    struct Output {
        // 영화 데이터 전 화면에서 안 넘어온 경우 alert
        let showAlert: Observable<Void> = Observable(())
        // 네비게이션바 및 영화정보뷰 업데이트
        let configureView: Observable<Void> = Observable(())
        // 백드롭 이미지
        var backdropImages: Observable<[ImagePath]> = Observable([])
        // 네트워크 에러 alert
        let showErrorAlert: Observable<StatusCode?> = Observable(nil)
        // 통신 완료 -> reload
        let completeNetwork: Observable<Void> = Observable(())
    }
    
    private(set) var input: Input
    private(set) var output: Output
    
    let likeButton = LikeButton()
    
    var castInfos: [Cast] = []
    var posterImages: [ImagePath] = []
    private let group = DispatchGroup()
    
    
    init() {
        input = Input()
        output = Output()
        transform()
    }
    
    func transform() {
        // 상세화면에서 보여줄 영화 정보
        input.movieInfo.lazyBind { [weak self] _ in
            self?.configureData()
        }
        
        // viewWillAppear
        input.viewWillAppearTrigger.lazyBind { [weak self] _ in
            self?.setLikeButton()
        }
    }
    
    private func configureData() {
        guard let movieInfo = input.movieInfo.value else {
            // show alert
            output.showAlert.value = ()
            return
        }
        // 네비게이션바 및 영화정보뷰 업데이트
        likeButton.id = movieInfo.id
        output.configureView.value = ()
        
        // 네트워크
        imageNetwork()
        castNetwork()
        
        group.notify(queue: .main) { [weak self] in
            self?.output.completeNetwork.value = ()
        }
    }
    
    private func imageNetwork() {
        guard let movieInfo = input.movieInfo.value else {
            print("movieInfo nil")
            return
        }
        
        group.enter()
        // 백드롭 + 포스터 이미지 네트워크
        NetworkManager.shared.getMovieData(api: .MovieImage(id: movieInfo.id), type: MovieImageModel.self) { [weak self] value in
            // 백드롭 이미지 5개까지만 넣기
            self?.output.backdropImages.value = Array(value.backdrops.prefix(5))
            // 포스터 이미지
            self?.posterImages = value.posters
            self?.group.leave()
        } failHandler: { [weak self] statusCode in
            self?.group.leave()
            self?.output.showErrorAlert.value = statusCode
        }
    }
    
    private func castNetwork() {
        guard let movieInfo = input.movieInfo.value else {
            print("movieInfo nil")
            return
        }
        
        group.enter()
        NetworkManager.shared.getMovieData(api: .Cast(id: movieInfo.id), type: CreditModel.self) { [weak self] value in
            self?.castInfos = value.cast
            self?.group.leave()
        } failHandler: { [weak self] statusCode in
            self?.group.leave()
            self?.output.showErrorAlert.value = statusCode
        }
    }
    
    private func setLikeButton() {
        if let id = likeButton.id,
           UserInfo.storedMovieList.contains(id) {
            likeButton.isSelected = true
        } else {
            likeButton.isSelected = false
        }
    }
}
