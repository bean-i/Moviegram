//
//  ProfileImageSettingViewController.swift
//  Moviegram
//
//  Created by 이빈 on 1/25/25.
//

import UIKit

final class ProfileImageSettingViewController: BaseViewController<ProfileImageSettingView> {
    
    var selectedImageNumber: Int = 0
    var passSelectedImageNumber: ((Int) -> Void)?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        passSelectedImageNumber?(self.selectedImageNumber)
    }
    
    override func configureView() {
        
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
        selectedImageNumber = indexPath.item
        mainView.profileImageView.imageNumber = selectedImageNumber
    }

}
