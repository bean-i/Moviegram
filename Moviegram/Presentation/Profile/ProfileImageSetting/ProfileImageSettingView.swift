//
//  ProfileImageSettingView.swift
//  Moviegram
//
//  Created by 이빈 on 1/25/25.
//

import UIKit
import SnapKit

// MARK: - 프로필 이미지 설정 View
final class ProfileImageSettingView: BaseView {

    // MARK: - Properties
    let profileImageView = ProfileImageView()
    private let cameraView = UIView()
    private let cameraImageView = UIImageView()
    
    let profileImageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    // MARK: - Configure UI
    override func layoutSubviews() {
        super.layoutSubviews()
        cameraView.layer.cornerRadius = cameraView.frame.width / 2
    }
    
    override func configureHierarchy() {
        cameraView.addSubview(cameraImageView)
        
        addSubViews(
            profileImageView,
            cameraView,
            profileImageCollectionView
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
        
        profileImageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(50)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        cameraView.backgroundColor = .point
        cameraView.isUserInteractionEnabled = true
        
        cameraImageView.image = UIImage(systemName: "camera.fill")
        cameraImageView.tintColor = .white
        cameraImageView.contentMode = .scaleAspectFit
        
        profileImageCollectionView.collectionViewLayout = profileImageCollectionViewLayout()
        profileImageCollectionView.backgroundColor = .clear
    }
    
    // MARK: - CollectionView Layout
    private func profileImageCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let inset: CGFloat = 30
        let spacing: CGFloat = 10
        let count: CGFloat = 4
        let deviceWidth = UIScreen.main.bounds.width
        let size = (deviceWidth - (2 * inset) - ((count - 1) * spacing)) / count
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.itemSize = CGSize(width: size, height: size)
        return layout
    }
    
}
