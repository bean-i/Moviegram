//
//  ProfileView.swift
//  Moviegram
//
//  Created by 이빈 on 1/28/25.
//

import UIKit
import SnapKit

// [메인, 세팅 화면] - 유저의 정보(닉네임, 프로필이미지 등)를 나타내는 박스 뷰
final class ProfileView: BaseView {
    
    private let profileImageView = ProfileImageView()
    private let profileNickNameLabel = UILabel()
    private let joinDateLabel = UILabel()
    private let chevronButton = UIImageView()
    private let movieStorageButton = UIButton()
    
    override func configureHierarchy() {
        addSubViews(
            profileImageView,
            profileNickNameLabel,
            joinDateLabel,
            chevronButton,
            movieStorageButton
        )
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(15)
            make.size.equalTo(60)
        }
        
        profileNickNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(25)
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
        }
        
        joinDateLabel.snp.makeConstraints { make in
            make.top.equalTo(profileNickNameLabel.snp.bottom).offset(3)
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
        }
        
        chevronButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(15)
            make.width.equalTo(15)
            make.height.equalTo(25)
        }
        
        movieStorageButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.bottom.equalToSuperview().inset(15)
            make.horizontalEdges.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
    }
    
    override func configureView() {
        isUserInteractionEnabled = true
        backgroundColor = .customDarkGray
        layer.cornerRadius = 15

        profileImageView.isSelected = true
        
        profileNickNameLabel.font = .Font.large.of(weight: .heavy)
        profileNickNameLabel.textColor = .white
        
        joinDateLabel.font = .Font.small.of(weight: .medium)
        joinDateLabel.textColor = .gray
        
        chevronButton.image = UIImage(systemName: "chevron.right")
        chevronButton.tintColor = .gray
        
        movieStorageButton.backgroundColor = .customTeal
        movieStorageButton.layer.cornerRadius = 10
        movieStorageButton.tintColor = .white
        movieStorageButton.titleLabel?.font = .Font.medium.of(weight: .bold)
    }
    
    func configureData(data: UserInfo) {
        guard let nickname = data.nickname,
              let imageNumber = data.imageNumber,
              let joinDate = data.joinDate,
              let storedMovies = data.storedMovies else {
            profileImageView.imageNumber = 0
            profileNickNameLabel.text = "이름 없음"
            joinDateLabel.text = "가입 날짜 없음"
            movieStorageButton.setTitle("0개의 무비박스 보관중", for: .normal)
            return
        }
        
        profileImageView.imageNumber = imageNumber
        profileNickNameLabel.text = nickname
        joinDateLabel.text = "\(joinDate) 가입"
        movieStorageButton.setTitle("\(storedMovies.count)개의 무비박스 보관중", for: .normal)
    }
    
}
