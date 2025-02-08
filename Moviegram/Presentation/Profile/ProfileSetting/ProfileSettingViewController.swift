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
    
    // MARK: - MVVM 추가
    let viewModel = ProfileSettingViewModel()
    
    override func bindData() {
        // 타이틀
        viewModel.outputEditModeText.bind { text in
            self.title = text
        }
        
        // editMode에 따라 뷰 다르게 보여주기
        viewModel.outputEditMode.bind { bool in
            self.configureSettingModeView()
            if bool {
                self.editModeNavigationBar()
                self.configureEditModeView()
            }
        }
        
        // 닉네임 상태 레이블
        viewModel.outputTextFieldText.bind { text in
            self.mainView.nicknameConditionStatusLabel.text = text
        }
        
        // 닉네임 상태 레이블에 따른 버튼 변화
        viewModel.outputApproveStatus.lazyBind { bool in
            self.mainView.completionButton.isEnabled = bool
            self.mainView.completionButton.backgroundColor = bool ? .point : .darkGray
        }
        
        // 프로필 이미지 선택 -> 화면 전환
        viewModel.outputProfileImageTapped.lazyBind { _ in
            let vc = ProfileImageSettingViewController()
            vc.viewModel.inputEditMode.value = self.viewModel.inputEditMode.value
            vc.selectedImageNumber = self.viewModel.randomImageNumber
            vc.passSelectedImageNumber = { value in
                self.viewModel.randomImageNumber = value
                self.mainView.profileImageView.imageNumber = value
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        // 저장 버튼 선택 이후 화면 전환
        viewModel.outputCompletionButtonTapped.lazyBind { bool in
            if bool {
                self.dismiss(animated: true)
            } else {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let window = windowScene.windows.first else { return }
                window.rootViewController = TabBarController()
                window.makeKeyAndVisible()
            }
        }
        
        // 취소 버튼 선택
        viewModel.outputCancelButtonTapped.lazyBind { _ in
            self.dismiss(animated: true)
        }
    }
    
    // MARK: - Configure
    override func configureGesture() {
        self.dismissKeyboardWhenTapped()
        
        mainView.nicknameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        mainView.completionButton.addTarget(self, action: #selector(completionButtonTapped), for: .touchUpInside)
        
        mainView.profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileImageTapped)))
        mainView.cameraView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileImageTapped)))
    }
    
    // MARK: - Methods: UI
    private func configureEditModeView() {
        if let userImageNumber = UserInfo.shared.imageNumber,
           let userNickname = UserInfo.shared.nickname {
            viewModel.randomImageNumber = userImageNumber
            mainView.nicknameTextField.text = userNickname
            viewModel.inputTextFieldText.value = userNickname
        }
    }
    
    private func configureSettingModeView() {
        mainView.completionButton.isHidden = viewModel.inputEditMode.value
        mainView.profileImageView.imageNumber = viewModel.randomImageNumber
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
        viewModel.outputProfileImageTapped.value = ()
    }
    
    @objc func cancelButtonTapped() {
        viewModel.outputCancelButtonTapped.value = ()
    }
    
    // MARK: - Methods - 닉네임 설정
    @objc func textFieldDidChange(_ textField: UITextField) {
        // 텍스트필드의 텍스트 값 넘겨주기
        viewModel.inputTextFieldText.value = textField.text
    }
    
    @objc func completionButtonTapped() {
        // 유저 정보 저장
        viewModel.inputCompletionButtonTapped.value = ()
    }
    
}
