//
//  ProfileImageSettingViewController.swift
//  Moviegram
//
//  Created by 이빈 on 1/25/25.
//

import UIKit

// MARK: - 프로필 이미지 설정 ViewController
final class ProfileImageSettingViewController: BaseViewController<ProfileImageSettingView> {
    
    // MARK: - Properties
    var selectedImageNumber: Int = 0
    var passSelectedImageNumber: ((Int) -> Void)?
    
    // MARK: - 생명주기
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        passSelectedImageNumber?(self.selectedImageNumber)
    }
    
    // MARK: - Configure
    override func configureView() {
        
        mainView.profileImageView.imageNumber = selectedImageNumber
        mainView.profileImageView.isSelected = true
        
        mainView.profileImageCollectionView.delegate = self
        mainView.profileImageCollectionView.dataSource = self
        mainView.profileImageCollectionView.register(ProfileImageCollectionViewCell.self, forCellWithReuseIdentifier: ProfileImageCollectionViewCell.identifier)
    }
    
}

// MARK: - Extension: CollectionView
extension ProfileImageSettingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCollectionViewCell.identifier, for: indexPath) as? ProfileImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.isSelected = false
        cell.imageNumber = indexPath.item
        
        if indexPath.item == selectedImageNumber {
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImageNumber = indexPath.item
        mainView.profileImageView.imageNumber = selectedImageNumber
    }

}
