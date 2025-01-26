//
//  ProfileSettingViewController.swift
//  Moviegram
//
//  Created by 이빈 on 1/24/25.
//

import UIKit

enum ConditionStatus {
    case approve
    case lengthLimit
    case specialCharacterLimit
    case numberLimit
    
    var description: String {
        switch self {
        case .approve:
            return "사용할 수 있는 닉네임이에요"
        case .lengthLimit:
            return "2글자 이상 10글자 미만으로 설정해 주세요"
        case .specialCharacterLimit:
            return "닉네임에 @, #, $, % 는 포함할 수 없어요"
        case .numberLimit:
            return "닉네임에 숫자는 포함할 수 없어요"
        }
    }
}

final class ProfileSettingViewController: BaseViewController<ProfileSettingView> {
    
    let randomImageNumber = Int.random(in: 0...11)
    let forbiddenStrings: [Character] = ["@", "#", "$", "%"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "프로필 설정"
    }
    
    override func configureView() {
        
        mainView.profileImageView.imageNumber = randomImageNumber
        
        mainView.nicknameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        mainView.completionButton.addTarget(self, action: #selector(completionButtonTapped), for: .touchUpInside)
        
        mainView.profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileImageTapped)))
        mainView.cameraView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileImageTapped)))
        
    }
    
    @objc func profileImageTapped() {
        print(#function)
        // 프로필 이미지 설정 화면으로 전환
        let vc = ProfileImageSettingViewController()
        vc.selectedImageNumber = randomImageNumber
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else {
            print("검사하지 않음")
            return
        }

        for str in text {
            // 특수문자 검사
            if forbiddenStrings.contains(String(str)) {
                updateNicknameConditionStatusLabel(ConditionStatus.specialCharacterLimit.description)
                return
            }
            
            // 숫자 검사
            if let _ = Int(String(str)) {
                updateNicknameConditionStatusLabel(ConditionStatus.numberLimit.description)
                return
            }
        }
        
        // 특수문자, 숫자 검사 통과하면
        // 길이 검사
        if text.count >= 2 && text.count < 10 {
            updateNicknameConditionStatusLabel(ConditionStatus.approve.description)
        } else {
            updateNicknameConditionStatusLabel(ConditionStatus.lengthLimit.description)
        }
        
    }
    
    func updateNicknameConditionStatusLabel(_ text: String) {
        mainView.nicknameConditionStatusLabel.text = text
        
        mainView.completionButton.isEnabled = false // approve인 경우에만, true로 설정
        if text == ConditionStatus.approve.description {
            // 완료 버튼 누를 수 있도록
            mainView.completionButton.isEnabled = true
        }
    }
    
    @objc func completionButtonTapped() {
        //WindowRootViewController 가 [메인 화면]으로 교체
        // 여기서 유저 정보 저장해야될 듯?
        print(#function)
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        window.rootViewController = UINavigationController(rootViewController: MainViewController())
        window.makeKeyAndVisible()
    }
    
}
