//
//  ProfileImageSettingViewModel.swift
//  Moviegram
//
//  Created by 이빈 on 2/8/25.
//

import Foundation

final class ProfileImageSettingViewModel {
    
    var imageCount: Int = 12
    
    // 역값 전달 클로저
    var passSelectedImageNumber: ((Int) -> Void)?
    
    // 타이틀
    var inputEditMode: Observable<Bool> = Observable(false)
    var outputEditModeText: Observable<String> = Observable("nil")
    
    // 선택된 이미지
    var outputSelectedImageNumber: Observable<Int> = Observable(0)
    
    // 화면 사라질 때
    var outputViewWillDisappearTrigger: Observable<Void?> = Observable(nil)
    
    init() {
        
        inputEditMode.lazyBind { _ in
            print(self.inputEditMode.value)
            self.outputEditModeText.value = self.inputEditMode.value ? "프로필 이미지 편집" : "프로필 이미지 설정"
        }
    }
    
}
