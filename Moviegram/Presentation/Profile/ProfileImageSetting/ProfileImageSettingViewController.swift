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
    let viewModel = ProfileImageSettingViewModel()
    
    // MARK: - 생명주기
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.outputViewWillDisappearTrigger.value = ()
    }
    
    // MARK: - MVVM 추가
    override func bindData() {
        // 타이틀
        viewModel.outputEditModeText.bind { text in
            self.title = text
        }
        
        // 상단 선택된 이미지
        viewModel.outputSelectedImageNumber.bind { int in
            self.mainView.profileImageView.imageNumber = int
            self.mainView.profileImageView.isSelected = true
        }
        
        // 화면 사라질 때, 역값전달
        viewModel.outputViewWillDisappearTrigger.lazyBind { _ in
            self.viewModel.passSelectedImageNumber?(self.viewModel.outputSelectedImageNumber.value)
        }
    }
    
    // MARK: - Configure
    override func configureDelegate() {
        mainView.profileImageCollectionView.delegate = self
        mainView.profileImageCollectionView.dataSource = self
        mainView.profileImageCollectionView.register(ProfileImageCollectionViewCell.self, forCellWithReuseIdentifier: ProfileImageCollectionViewCell.identifier)
    }
}

// MARK: - Extension: CollectionView
extension ProfileImageSettingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCollectionViewCell.identifier, for: indexPath) as? ProfileImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.isSelected = false
        cell.imageNumber = indexPath.item
        
        if indexPath.item == viewModel.outputSelectedImageNumber.value {
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.outputSelectedImageNumber.value = indexPath.item
        mainView.profileImageView.imageNumber = viewModel.outputSelectedImageNumber.value
    }

}
