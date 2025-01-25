//
//  ProfileSettingView.swift
//  Moviegram
//
//  Created by 이빈 on 1/24/25.
//

import UIKit
import SnapKit

final class ProfileSettingView: BaseView {
    
    let profileImageView = ProfileImageView(
        imageNumber: Int.random(in: 0...11),
        isSelected: true
    )
    let cameraView = UIView()
    let cameraImageView = UIImageView()
    
    let nicknameTextField = UITextField()
    let nicknameTextFieldUnderLine = UIView()
    
    let nicknameConditionStatusLabel = UILabel()
    
    let completionButton = UIButton()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cameraView.layer.cornerRadius = cameraView.frame.width / 2
    }

    override func configureHierarchy() {
        
        cameraView.addSubview(cameraImageView)
        
        addSubViews(
            profileImageView,
            cameraView,
            nicknameTextField,
            nicknameTextFieldUnderLine,
            nicknameConditionStatusLabel,
            completionButton
        )
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(30)
            make.centerX.equalToSuperview()
            make.size.equalTo(100)
        }
        
        cameraView.snp.makeConstraints { make in
            make.trailing.equalTo(profileImageView.snp.trailing)
            make.bottom.equalTo(profileImageView.snp.bottom)
            make.size.equalTo(30)
        }
        
        cameraImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(20)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        nicknameTextFieldUnderLine.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.height.equalTo(1)
        }
        
        nicknameConditionStatusLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextFieldUnderLine.snp.bottom).offset(15)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        completionButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameConditionStatusLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(15)
            make.height.equalTo(44)
        }
        
    }
    
    override func configureView() {
        cameraView.backgroundColor = .point
        cameraView.isUserInteractionEnabled = true
        
        cameraImageView.image = UIImage(systemName: "camera.fill")
        cameraImageView.tintColor = .white
        cameraImageView.contentMode = .scaleAspectFit
        
        nicknameTextField.textColor = .white
        
        nicknameTextFieldUnderLine.backgroundColor = .white
        
        nicknameConditionStatusLabel.textAlignment = .left
        nicknameConditionStatusLabel.textColor = .point
        nicknameConditionStatusLabel.font = .Font.small.of(weight: .medium)
        
        completionButton.setTitle("완료", for: .normal)
        completionButton.titleLabel?.font = .Font.large.of(weight: .heavy)
        completionButton.setTitleColor(.point, for: .normal)
        completionButton.backgroundColor = .black
        completionButton.layer.cornerRadius = 20
        completionButton.layer.borderWidth = 2
        completionButton.layer.borderColor = UIColor.point.cgColor
        completionButton.isEnabled = false
    }

}
