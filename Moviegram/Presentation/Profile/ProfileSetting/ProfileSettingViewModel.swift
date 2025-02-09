//
//  ProfileSettingViewModel.swift
//  Moviegram
//
//  Created by 이빈 on 2/8/25.
//

import Foundation

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

// MARK: - 뷰모델
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
    
    // MBTI
    var mbti: Set<String> = []
    var inputMBTI: Observable<String> = Observable("")
    
    // 취소버튼 탭
    var outputCancelButtonTapped: Observable<Void?> = Observable(nil)
    
    // 저장버튼 탭
    var inputCompletionButtonTapped: Observable<Void?> = Observable(nil)
    var outputCompletionButtonTapped: Observable<Bool> = Observable(false)
    
    var outputCompletionButtonEnabled: Observable<Bool> = Observable(false)
    
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
        
        inputMBTI.lazyBind { _ in
            self.setMBTI()
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
                checkCompletion()
                return
            }
            
            // 숫자 검사
            if let _ = Int(String(str)) {
                outputTextFieldText.value = ConditionStatus.numberLimit.description
                checkCompletion()
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
        }
        checkCompletion()
    }

    private func saveUserInfo() {
        
        guard let nickname = inputTextFieldText.value else {
            print("텍스트필드 오류")
            return
        }
        
        UserInfo.shared.imageNumber = randomImageNumber
        UserInfo.shared.nickname = nickname
        UserInfo.shared.mbti = Array(mbti)
        
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
    
    // MBTI 컬렉션뷰의 데이터 저장
    // 데이터 있으면 삭제, 없으면 추가
    private func setMBTI() {
        let data = inputMBTI.value
        if mbti.contains(data) {
            mbti.remove(data)
        } else {
            mbti.insert(data)
        }
        checkCompletion()
    }
    
    // 저장 버튼 업데이트
    private func checkCompletion() {
        print(#function)
        print(mbti)
        if outputTextFieldText.value == ConditionStatus.approve.description,
           mbti.count == 4 {
            print("저장 가능")
            outputCompletionButtonEnabled.value = true
        } else {
            print("저장 불가능")
            outputCompletionButtonEnabled.value = false
        }
    }
}
