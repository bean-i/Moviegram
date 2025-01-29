//
//  SettingViewController.swift
//  Moviegram
//
//  Created by 이빈 on 1/26/25.
//

import UIKit

enum SettingOptions: String, CaseIterable {
    case questions = "자주 묻는 질문"
    case contact = "1:1 문의"
    case alertSetting = "알림 설정"
    case signOut = "탈퇴하기"
}

final class SettingViewController: BaseViewController<SettingView> {

    override func configureView() {
        navigationItem.title = "설정"
        mainView.profileView.configureData(data: UserInfo.shared)
        
        mainView.settingTableView.delegate = self
        mainView.settingTableView.dataSource = self
        mainView.settingTableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
    }
    
    func deleteAllUserData() {
        for key in UserInfoKey.allCases {
            UserDefaults.standard.removeObject(forKey: key.rawValue)
        }
        UserInfo.storedMovieList = [] // 이거 왜 해야되는지..?
    }
    
    func switchToOnboardingScreen() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        window.rootViewController = UINavigationController(rootViewController: OnboardingViewController())
        window.makeKeyAndVisible()
    }

}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingOptions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as! SettingTableViewCell
        
        cell.settingOptionLabel.text = SettingOptions.allCases[indexPath.row].rawValue
        
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
