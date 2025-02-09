//
//  ProfileSettingView.swift
//  Moviegram
//
//  Created by 이빈 on 1/24/25.
//

import UIKit
import SnapKit

// MARK: - 프로필 설정 View
final class ProfileSettingView: BaseView {
    
    // MARK: - Properties
    let profileImageView = ProfileImageView()
    
    let cameraView = UIView()
    private let cameraImageView = UIImageView()
    
    let nicknameTextField = UITextField()
    private let nicknameTextFieldUnderLine = UIView()
    
    let nicknameConditionStatusLabel = UILabel()
    
    private let mbtiLabel = UILabel()
    private let stackView = UIStackView()
    let mbtiCollectionViews = [
        MBTICollectionView(mbtiData: ["E", "I"]),
        MBTICollectionView(mbtiData: ["S", "N"]),
        MBTICollectionView(mbtiData: ["T", "F"]),
        MBTICollectionView(mbtiData: ["J", "P"])
    ]
    
    let completionButton = UIButton()
    
    // MARK: - Configure UI
    override func layoutSubviews() {
        super.layoutSubviews()
        cameraView.layer.cornerRadius = cameraView.frame.width / 2
    }

    override func configureHierarchy() {
        
        mbtiCollectionViews.forEach { stackView.addArrangedSubview($0) }
        
        cameraView.addSubview(cameraImageView)
        
        addSubViews(
            profileImageView,
            cameraView,
            nicknameTextField,
            nicknameTextFieldUnderLine,
            nicknameConditionStatusLabel,
            mbtiLabel,
            stackView,
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
        
        mbtiLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameConditionStatusLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview().inset(20)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(nicknameConditionStatusLabel.snp.bottom).offset(30)
            make.trailing.equalToSuperview().inset(10)
            make.width.equalTo(270)
            make.height.equalTo(130)
        }
        
        completionButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(15)
            make.height.equalTo(44)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
    }
    
    override func configureView() {
        profileImageView.isSelected = true
        
        cameraView.backgroundColor = .point
        cameraView.isUserInteractionEnabled = true
        
        cameraImageView.image = UIImage(systemName: "camera.fill")
        cameraImageView.tintColor = .white
        cameraImageView.contentMode = .scaleAspectFit
        
        nicknameTextField.textColor = .white
        nicknameTextField.placeholder = "닉네임을 입력해주세요 :)"
        nicknameTextField.font = .Font.medium.of(weight: .medium)
        nicknameTextField.setPlaceholder(color: .customGray)
        
        
        nicknameTextFieldUnderLine.backgroundColor = .white
        
        nicknameConditionStatusLabel.textAlignment = .left
        nicknameConditionStatusLabel.textColor = .point
        nicknameConditionStatusLabel.font = .Font.small.of(weight: .medium)
        
        mbtiLabel.text = "MBTI"
        mbtiLabel.textColor = .white
        mbtiLabel.font = .Font.large.of(weight: .bold)
        
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        completionButton.setTitle("완료", for: .normal)
        completionButton.titleLabel?.font = .Font.large.of(weight: .heavy)
        completionButton.setTitleColor(.white, for: .normal)
        completionButton.backgroundColor = .darkGray
        completionButton.layer.cornerRadius = 20
        completionButton.layer.borderWidth = 2
        completionButton.isEnabled = false
    }
    
    private func configureCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 60, height: 60)
        return layout
    }

}
