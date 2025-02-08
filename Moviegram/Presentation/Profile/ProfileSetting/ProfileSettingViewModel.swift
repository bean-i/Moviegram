//
//  ProfileSettingViewModel.swift
//  Moviegram
//
//  Created by 이빈 on 2/8/25.
//

import Foundation

final class ProfileSettingViewModel {
    
    var randomImageNumber = Int.random(in: 0...11)
    let forbiddenStrings: [Character] = ["@", "#", "$", "%"]
    weak var delegate: PassUserInfoDelegate?
    
    // 타이틀
    var inputEditMode: Observable<Bool> = Observable(false)
    var outputEditMode: Observable<Bool> = Observable(false)
    var outputEditModeText: Observable<String> = Observable("nil")
    
    // 닉네임 텍스트필드
    var inputTextFieldText: Observable<String?> = Observable(nil)
    var outputTextFieldText: Observable<String> = Observable("")
    var outputApproveStatus: Observable<Bool> = Observable(false)
    
    // 프로필 이미지 탭
    var outputProfileImageTapped: Observable<Void?> = Observable(nil)
    
    // 취소버튼 탭
    var outputCancelButtonTapped: Observable<Void?> = Observable(nil)
    
    // 저장버튼 탭
    var inputCompletionButtonTapped: Observable<Void?> = Observable(nil)
    var outputCompletionButtonTapped: Observable<Bool> = Observable(false)
    
    init() {
        
        inputEditMode.lazyBind { bool in
            self.outputEditModeText.value = self.inputEditMode.value ? "프로필 편집" : "프로필 설정"
            self.outputEditMode.value = bool
        }
        
        inputTextFieldText.lazyBind { _ in
            self.checkNicknameConditionStatus()
        }
        
        inputCompletionButtonTapped.lazyBind { _ in
            self.saveUserInfo()
        }
        
    }
    
    private func checkNicknameConditionStatus() {
        guard let text = inputTextFieldText.value else {
            print("텍스트필드 오류")
            return
        }

        for str in text {
            outputApproveStatus.value = false
            // 특수문자 검사
            if forbiddenStrings.contains(String(str)) {
                outputTextFieldText.value = ConditionStatus.specialCharacterLimit.description
                return
            }
            
            // 숫자 검사
            if let _ = Int(String(str)) {
                outputTextFieldText.value = ConditionStatus.numberLimit.description
                return
            }
        }
        
        // 특수문자, 숫자 검사 통과하면
        // 길이 검사
        if text.count >= 2 && text.count < 10 {
            outputTextFieldText.value = ConditionStatus.approve.description
            outputApproveStatus.value = true
        } else {
            outputTextFieldText.value = ConditionStatus.lengthLimit.description
            outputApproveStatus.value = false
        }
    }

    private func saveUserInfo() {
        
        guard let nickname = inputTextFieldText.value else {
            print("텍스트필드 오류")
            return
        }
        
        UserInfo.shared.imageNumber = randomImageNumber
        UserInfo.shared.nickname = nickname
        
        if inputEditMode.value {
            delegate?.passUserInfo()
            outputCompletionButtonTapped.value = inputEditMode.value
        } else {
            UserInfo.shared.joinDate = DateFormatter.stringFromDate(Date())
            UserInfo.shared.storedMovies = []
            UserInfo.shared.isRegistered = true
            outputCompletionButtonTapped.value = inputEditMode.value
        }
    }
}
