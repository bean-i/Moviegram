//
//  BackdropCollectionViewCell.swift
//  Moviegram
//
//  Created by 이빈 on 1/29/25.
//

import UIKit
import Kingfisher
import SnapKit

final class BackdropCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "BackdropCollectionViewCell"
    
    private let backdropImageView = UIImageView()
    
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
    
    func configureData(url: String) {
        
        if let url = URL(string: TMDBAPI.imageBaseURL + url) {
            backdropImageView.kf.setImage(with: url)
        }
        
    }
    
}
