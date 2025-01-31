//
//  SettingViewController.swift
//  Moviegram
//
//  Created by 이빈 on 1/26/25.
//

import UIKit

// MARK: - 세팅 옵션
enum SettingOptions: String, CaseIterable {
    case questions = "자주 묻는 질문"
    case contact = "1:1 문의"
    case alertSetting = "알림 설정"
    case signOut = "탈퇴하기"
}

// MARK: - 설정 ViewController
final class SettingViewController: BaseViewController<SettingView> {

    // MARK: - 생명주기
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainView.profileView.configureData(data: UserInfo.shared)
    }
    
    // MARK: - Configure
    override func configureView() {
        navigationItem.title = "설정"
    }
    
    override func configureDelegate() {
        mainView.settingTableView.delegate = self
        mainView.settingTableView.dataSource = self
        mainView.settingTableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
    }
    
    override func configureGesture() {
        mainView.profileView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(profileViewTapped)
            )
        )
    }
    
    // MARK: - Methods
    // 프로필 편집 모달 띄우기
    @objc private func profileViewTapped() {
        let vc = ProfileSettingViewController()
        vc.isEditMode = true
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        
        nav.sheetPresentationController?.prefersGrabberVisible = true
        
        present(nav, animated: true)
    }
    
    // 유저 데이터 모두 삭제
    private func deleteAllUserData() {
        UserInfo.storedMovieList = []
        for key in UserInfoKey.allCases {
            UserDefaults.standard.removeObject(forKey: key.rawValue)
        }
    }
    
    // 루트뷰 온보딩으로 설정 및 전환
    private func switchToOnboardingScreen() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        window.rootViewController = UINavigationController(rootViewController: OnboardingViewController())
        window.makeKeyAndVisible()
    }

}

// MARK: - Extension: TableView
extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingOptions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as! SettingTableViewCell
        
        let text = SettingOptions.allCases[indexPath.row].rawValue
        cell.configureData(text: text)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 탈퇴하기 선택 -> alert
        if SettingOptions.allCases[indexPath.row] == SettingOptions.signOut {
            showAlert(
                title: "탈퇴하기",
                message: "탈퇴를 하면 데이터가 모두 초기화됩니다. 탈퇴 하시겠습니까?",
                cancel: true) {
                    // 확인 버튼 누르면
                    // 1. 유저 데이터 삭제
                    self.deleteAllUserData()
                    // 2. 온보딩 화면으로 전환
                    self.switchToOnboardingScreen()
                }
        }
    }
}

// MARK: - Extension: Delegate
extension SettingViewController: passUserInfoDelegate {
    func passUserInfo() {
        mainView.profileView.configureData(data: UserInfo.shared)
    }
}
