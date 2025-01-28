//
//  ProfileView.swift
//  Moviegram
//
//  Created by 이빈 on 1/28/25.
//

import UIKit
import SnapKit

final class ProfileView: BaseView {
    
    let profileImageView = ProfileImageCustomView()
    let profileNickNameLabel = UILabel()
    let joinDateLabel = UILabel()
    let chevronButton = UIImageView()
    let movieStorageButton = UIButton()
    
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
            print("유저 인포 오류") // 얼럿 띄워줘야하나. . .?
            return
        }
        
        profileImageView.imageNumber = imageNumber
        profileNickNameLabel.text = nickname
        joinDateLabel.text = "\(joinDate) 가입"
        movieStorageButton.setTitle("\(storedMovies.count)개의 무비박스 보관중", for: .normal)
    }
    
}
