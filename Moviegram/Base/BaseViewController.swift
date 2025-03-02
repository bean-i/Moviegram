//
//  BaseViewController.swift
//  Moviegram
//
//  Created by 이빈 on 1/24/25.
//

import UIKit

class BaseViewController<T: UIView>: UIViewController {
    
    var mainView: T {
        guard let customView = view as? T else {
            fatalError("view는 \(T.self) 타입이어야 합니다.")
        }
        return customView
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        bindData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = T(frame: .zero)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureDelegate()
        configureGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .black
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }
    
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
