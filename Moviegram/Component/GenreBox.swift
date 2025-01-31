//
//  GenreBox.swift
//  Moviegram
//
//  Created by 이빈 on 1/28/25.
//

import UIKit
import SnapKit

// [검색 결과 화면] - 장르 정보 UI
final class GenreBox: BaseView {
    
    private let genreLabel = UILabel()
    
    var genreTitleId: Int = 0 {
        didSet {
            genreLabel.text = Genre.getGenre(id: genreTitleId)
        }
    }
    
    override func configureHierarchy() {
        addSubview(genreLabel)
    }
    
    override func configureLayout() {
        genreLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
    }
    
    override func configureView() {
        backgroundColor = .darkGray
        layer.cornerRadius = 5
        
        genreLabel.font = .Font.small.of(weight: .medium)
        genreLabel.textColor = .white
    }
    
}
