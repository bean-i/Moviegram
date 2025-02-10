//
//  ProfileImageSettingViewModel.swift
//  Moviegram
//
//  Created by 이빈 on 2/8/25.
//

import Foundation

final class ProfileImageSettingViewModel: BaseViewModel {
    // MARK: - Properties
    // 역값 전달 클로저
    var passSelectedImageNumber: ((Int) -> Void)?
    var imageCount: Int = 12
    
    private(set) var input: Input
    private(set) var output: Output

    init() {
        input = Input()
        output = Output()
        transform()
    }
    
    func transform() {
        input.editMode.lazyBind { [weak self] _ in
            guard let self else {
                print("self 오류")
                return
            }
            
            self.output.editModeText.value = self.input.editMode.value ? "프로필 이미지 편집" : "프로필 이미지 설정"
        }
    }
    
}

// MARK: - Input Output
extension ProfileImageSettingViewModel {
    
    struct Input {
        // 타이틀
        var editMode: Observable<Bool> = Observable(false)
    }
    
    struct Output {
        // 타이틀
        var editModeText: Observable<String> = Observable("nil")
        
        // 선택된 이미지
        var selectedImageNumber: Observable<Int> = Observable(0)
        
        // 화면 사라질 때
        var viewWillDisappearTrigger: Observable<Void?> = Observable(nil)
    }
}
