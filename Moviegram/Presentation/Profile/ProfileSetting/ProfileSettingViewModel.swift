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
final class ProfileSettingViewModel: BaseViewModel {
    // MARK: - Properties
    var randomImageNumber = Int.random(in: 0...11)
    let forbiddenStrings: [Character] = ["@", "#", "$", "%"]
    var mbti: Set<String> = []
    
    weak var delegate: PassUserInfoDelegate?
    
    private(set) var input: Input
    private(set) var output: Output
    
    init() {
        input = Input()
        output = Output()
        
        transform()
    }
    
    func transform() {
        input.editMode.lazyBind { [weak self] bool in
        
            guard let self else {
                return
            }
            
            self.output.editModeText.value = self.input.editMode.value ? "프로필 편집" : "프로필 설정"
            self.output.editMode.value = bool
        }
        
        input.textFieldText.lazyBind { [weak self] _ in
            self?.checkNicknameConditionStatus()
        }
        
        input.completionButtonTapped.lazyBind { [weak self] _ in
            self?.saveUserInfo()
        }
        
        input.mbti.lazyBind { [weak self] _ in
            self?.setMBTI()
        }
    }
    
    private func checkNicknameConditionStatus() {
        guard let text = input.textFieldText.value else {
            print("텍스트필드 오류")
            return
        }

        for str in text {
            output.approveStatus.value = false
            // 특수문자 검사
            if forbiddenStrings.contains(String(str)) {
                output.textFieldText.value = ConditionStatus.specialCharacterLimit.description
                checkCompletion()
                return
            }
            
            // 숫자 검사
            if let _ = Int(String(str)) {
                output.textFieldText.value = ConditionStatus.numberLimit.description
                checkCompletion()
                return
            }
        }
        
        // 특수문자, 숫자 검사 통과하면
        // 길이 검사
        if text.count >= 2 && text.count < 10 {
            output.textFieldText.value = ConditionStatus.approve.description
            output.approveStatus.value = true
        } else {
            output.textFieldText.value = ConditionStatus.lengthLimit.description
        }
        checkCompletion()
    }

    private func saveUserInfo() {
        
        guard let nickname = input.textFieldText.value else {
            print("텍스트필드 오류")
            return
        }
        
        UserInfo.shared.imageNumber = randomImageNumber
        UserInfo.shared.nickname = nickname
        UserInfo.shared.mbti = Array(mbti)
        
        if input.editMode.value {
            delegate?.passUserInfo()
            output.completionButtonTapped.value = input.editMode.value
        } else {
            UserInfo.shared.joinDate = DateFormatter.stringFromDate(Date())
            UserInfo.shared.storedMovies = []
            UserInfo.shared.isRegistered = true
            output.completionButtonTapped.value = input.editMode.value
        }
    }
    
    // MBTI 컬렉션뷰의 데이터 저장
    // 데이터 있으면 삭제, 없으면 추가
    private func setMBTI() {
        let data = input.mbti.value
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
        if output.textFieldText.value == ConditionStatus.approve.description,
           mbti.count == 4 {
            print("저장 가능")
            output.completionButtonEnabled.value = true
        } else {
            print("저장 불가능")
            output.completionButtonEnabled.value = false
        }
    }
}

// MARK: - Input Output
extension ProfileSettingViewModel {
    
    struct Input {
        // 타이틀
        var editMode: Observable<Bool> = Observable(false)
        
        // 닉네임 텍스트필드
        var textFieldText: Observable<String?> = Observable(nil)
        
        // MBTI
        var mbti: Observable<String> = Observable("")
        
        // 저장버튼 탭
        var completionButtonTapped: Observable<Void?> = Observable(nil)
    }
    
    struct Output {
        // 타이틀
        var editMode: Observable<Bool> = Observable(false)
        var editModeText: Observable<String> = Observable("nil")
        
        // 닉네임 텍스트필드
        var textFieldText: Observable<String> = Observable("")
        var approveStatus: Observable<Bool> = Observable(false)
        
        // 취소버튼 탭
        var cancelButtonTapped: Observable<Void?> = Observable(nil)
        
        // 프로필 이미지 탭
        var profileImageTapped: Observable<Void?> = Observable(nil)
        
        // 저장버튼 탭
        var completionButtonTapped: Observable<Bool> = Observable(false)
        var completionButtonEnabled: Observable<Bool> = Observable(false)
    }
}
