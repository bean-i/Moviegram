//
//  BaseViewController.swift
//  Moviegram
//
//  Created by 이빈 on 1/24/25.
//

import UIKit

class BaseViewController<T: UIView>: UIViewController {
    
    var mainView: T {
        return view as! T
    }
    
    override func loadView() {
        self.view = T(frame: UIScreen.main.bounds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureView()
        configureDelegate()
        configureGesture()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .black
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }
    
    func configureHierarchy() { }
    
    func configureLayout() { }
    
    func configureView() { }
    
    func configureDelegate() { }
    
    func configureGesture() { }
    
    func bindData() { }
    
}

extension BaseViewController: LikeButtonDelegate {
    
    func likeButtonTapped(id: Int, isSelected: Bool) {
        if isSelected { // true이면 저장
            UserInfo.shared.storedMovies = [id]
        } else { // false이면 삭제
            if let index = UserInfo.storedMovieList.firstIndex(of: id) {
                UserInfo.storedMovieList.remove(at: index)
                UserInfo.shared.storedMovies = Array(UserInfo.storedMovieList) // 새로운 집합으로 업데이트
            }
        }
        // 메인 뷰인 경우에: 버튼 터치 시, 프로필 뷰 업데이트 (실시간 반영)
        if let currentView = mainView as? MainView {
            currentView.profileView.configureData(data: UserInfo.shared)
        }
    }
}
