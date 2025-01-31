//
//  BackdropCollectionViewCell.swift
//  Moviegram
//
//  Created by 이빈 on 1/29/25.
//

import UIKit

import Kingfisher
import SnapKit

// MARK: - 백드롭 CollectionViewCell
final class BackdropCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Properties
    static let identifier = "BackdropCollectionViewCell"
    
    private let backdropImageView = UIImageView()
    
    // MARK: - Configure UI
    override func configureHierarchy() {
        addSubview(backdropImageView)
    }
    
    override func configureLayout() {
        backdropImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        backdropImageView.clipsToBounds = true
        backdropImageView.backgroundColor = .black
        backdropImageView.contentMode = .scaleAspectFill
    }
    
    // MARK: - Configure Data
    func configureData(url: String) {
        
        if let url = URL(string: TMDBAPI.imageBaseURL + url) {
            backdropImageView.kf.setImage(with: url)
        }
        
    }
    
}
