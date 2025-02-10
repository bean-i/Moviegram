//
//  ProfileSettingViewController.swift
//  Moviegram
//
//  Created by 이빈 on 1/24/25.
//

import UIKit

// MARK: - 프로필 설정 ViewController
final class ProfileSettingViewController: BaseViewController<ProfileSettingView> {
    
    // MARK: - MVVM 추가
    let viewModel = ProfileSettingViewModel()
    weak var delegate: PassMBTIDelegate?
    
    deinit {
        print("ProfileSettingViewController Deinit")
    }
    
    override func bindData() {
        // 타이틀
        viewModel.output.editModeText.bind { [weak self] text in
            self?.title = text
        }
        
        // editMode에 따라 뷰 다르게 보여주기
        viewModel.output.editMode.bind { [weak self] bool in
            self?.configureSettingModeView()
            if bool {
                self?.editModeNavigationBar()
                self?.configureEditModeView()
            }
        }
        
        // 닉네임 상태 레이블
        viewModel.output.textFieldText.bind { [weak self] text in
            self?.mainView.nicknameConditionStatusLabel.text = text
        }
        
        // 닉네임 상태 레이블에 따른 변화
        viewModel.output.approveStatus.lazyBind { [weak self] bool in
            self?.mainView.nicknameConditionStatusLabel.textColor = bool ? .point : .customRed
        }
        
        viewModel.output.completionButtonEnabled.lazyBind { [weak self] bool in
            self?.mainView.completionButton.isEnabled = bool
            self?.navigationItem.rightBarButtonItem?.isEnabled = bool
            self?.mainView.completionButton.backgroundColor = bool ? .point : .darkGray
        }
        
        // 프로필 이미지 선택 -> 화면 전환
        viewModel.output.profileImageTapped.lazyBind { [weak self] _ in
            let vc = ProfileImageSettingViewController()
            vc.viewModel.input.editMode.value = self?.viewModel.input.editMode.value ?? false
            vc.viewModel.output.selectedImageNumber.value = self?.viewModel.randomImageNumber ?? 0
            vc.viewModel.passSelectedImageNumber = { value in
                self?.viewModel.randomImageNumber = value
                self?.mainView.profileImageView.imageNumber = value
            }
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        // 저장 버튼 선택 이후 화면 전환
        viewModel.output.completionButtonTapped.lazyBind { [weak self] bool in
            if bool {
                self?.dismiss(animated: true)
            } else {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let window = windowScene.windows.first else { return }
                window.rootViewController = TabBarController()
                window.makeKeyAndVisible()
            }
        }
        
        // 취소 버튼 선택
        viewModel.output.cancelButtonTapped.lazyBind { [weak self] _ in
            self?.dismiss(animated: true)
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
    
    override func configureDelegate() {
        // 4개의 컬렉션뷰 delegate 설정
        let mbtis = mainView.mbtiCollectionViews
        for item in mbtis {
            item.delegate = self
        }
    }
    
    // MARK: - Methods: UI
    private func configureEditModeView() {
        print("editmode")
        if let userImageNumber = UserInfo.shared.imageNumber,
           let userNickname = UserInfo.shared.nickname,
           let mbti = UserInfo.shared.mbti{
            mainView.profileImageView.imageNumber = userImageNumber
            mainView.nicknameTextField.text = userNickname
            viewModel.randomImageNumber = userImageNumber
            viewModel.input.textFieldText.value = userNickname
            
            // 네개의 컬렉션뷰에 mbti 표시하기
            for currentView in mainView.mbtiCollectionViews {
                for m in mbti {
                    for (index, data) in currentView.mbtiData.enumerated() {
                        if data == m {
                            currentView.collectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: .centeredHorizontally)
                        }
                    }
                }
            }
        }
    }
    
    private func configureSettingModeView() {
        mainView.completionButton.isHidden = viewModel.input.editMode.value
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
        viewModel.output.profileImageTapped.value = ()
    }
    
    @objc func cancelButtonTapped() {
        viewModel.output.cancelButtonTapped.value = ()
    }
    
    // MARK: - Methods - 닉네임 설정
    @objc func textFieldDidChange(_ textField: UITextField) {
        // 텍스트필드의 텍스트 값 넘겨주기
        viewModel.input.textFieldText.value = textField.text
    }
    
    @objc func completionButtonTapped() {
        // 유저 정보 저장
        viewModel.input.completionButtonTapped.value = ()
    }
    
}

extension ProfileSettingViewController: PassMBTIDelegate {
    
    func passMBTI(data: String) {
        viewModel.input.mbti.value = data
    }
    
}

