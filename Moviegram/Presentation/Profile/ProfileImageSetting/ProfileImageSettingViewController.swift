//
//  ProfileImageSettingViewController.swift
//  Moviegram
//
//  Created by 이빈 on 1/25/25.
//

import UIKit

final class ProfileImageSettingViewController: BaseViewController<ProfileImageSettingView> {
    
    var selectedImageNumber: Int = 0
    
    override func configureView() {
        title = "프로필 이미지 설정"
        
        mainView.profileImageView.imageNumber = selectedImageNumber
        mainView.profileImageView.isSelected = true
        
        mainView.profileImageCollectionView.delegate = self
        mainView.profileImageCollectionView.dataSource = self
        mainView.profileImageCollectionView.register(ProfileImageCollectionViewCell.self, forCellWithReuseIdentifier: ProfileImageCollectionViewCell.identifier)
    }
    
}

extension ProfileImageSettingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCollectionViewCell.identifier, for: indexPath) as! ProfileImageCollectionViewCell
        
        cell.isSelected = false
        cell.imageNumber = indexPath.item
        
        if indexPath.item == selectedImageNumber {
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedCell = collectionView.cellForItem(at: indexPath) as? ProfileImageCollectionViewCell else {
            print("셀 선택 오류")
            return
        }
        
        mainView.profileImageView.imageNumber = selectedCell.imageNumber
    }

}
