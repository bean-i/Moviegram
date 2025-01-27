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

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        print(#function)
        // 음.. 그냥 새로 만들자!!!
//        let nav = UINavigationController(rootViewController: profileNicknameEditViewController())
        
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
