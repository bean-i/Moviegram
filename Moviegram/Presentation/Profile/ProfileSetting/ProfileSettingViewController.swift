//
//  ProfileSettingViewController.swift
//  Moviegram
//
//  Created by 이빈 on 1/24/25.
//

import UIKit

// MARK: - 닉네임 조건 상태
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

// MARK: - 프로필 설정 ViewController
final class ProfileSettingViewController: BaseViewController<ProfileSettingView> {
    
    // MARK: - Properties
    private var randomImageNumber = Int.random(in: 0...11)
    private let forbiddenStrings: [Character] = ["@", "#", "$", "%"]
    var isEditMode = false
    weak var delegate: passUserInfoDelegate?
    
    // MARK: - Configure
    override func configureView() {
        if isEditMode {
            editModeNavigationBar()
            configureEditModeView()
            title = "프로필 편집"
        } else {
            configureSettingModeView()
            title = "프로필 설정"
        }
    }
    
    override func configureGesture() {
        self.dismissKeyboardWhenTapped()
        
        mainView.nicknameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        mainView.completionButton.addTarget(self, action: #selector(completionButtonTapped), for: .touchUpInside)
        
        mainView.profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileImageTapped)))
        mainView.cameraView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileImageTapped)))
    }
    
    // MARK: - Methods: UI
    private func configureEditModeView() {
        mainView.completionButton.isHidden = true
        if let userImageNumber = UserInfo.shared.imageNumber,
           let userNickname = UserInfo.shared.nickname {
            randomImageNumber = userImageNumber
            mainView.profileImageView.imageNumber = randomImageNumber
            mainView.nicknameTextField.text = userNickname
        }
    }
    
    private func configureSettingModeView() {
        mainView.completionButton.isHidden = false
        mainView.profileImageView.imageNumber = randomImageNumber
    }
    
    private func editModeNavigationBar() {
        title =  "프로필 편집"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(cancelButtonTapped)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "저장",
            style: .plain,
            target: self,
            action: #selector(completionButtonTapped)
        )
    }
    
    @objc func profileImageTapped() {
        // 프로필 이미지 설정 화면으로 전환
        let vc = ProfileImageSettingViewController()
        vc.title = isEditMode ? "프로필 이미지 편집" : "프로필 이미지 설정"
        vc.selectedImageNumber = randomImageNumber
        vc.passSelectedImageNumber = { value in
            self.randomImageNumber = value
            self.mainView.profileImageView.imageNumber = value
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    // MARK: - Methods - 닉네임 설정
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else {
            showAlert(
                title: "텍스트 오류",
                message: "검색어를 다시 작성해 주세요.",
                cancel: false) { }
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
        // 유저 정보 저장
        UserInfo.shared.imageNumber = randomImageNumber
        UserInfo.shared.nickname = mainView.nicknameTextField.text
        
        if isEditMode {
            delegate?.passUserInfo()
            dismiss(animated: true)
        } else {
            UserInfo.shared.joinDate = DateFormatter.stringFromDate(Date())
            UserInfo.shared.storedMovies = []
            UserInfo.shared.isRegistered = true
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else { return }
            window.rootViewController = TabBarController()
            window.makeKeyAndVisible()
        }
    }
    
}
