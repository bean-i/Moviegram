//
//  GenreBox.swift
//  Moviegram
//
//  Created by 이빈 on 1/28/25.
//

import UIKit
import SnapKit

final class GenreBox: BaseView {
    
    let genreLabel = UILabel()
    var genreTitleId: Int = 0 {
        didSet {
            genreLabel.text = configureGenreTitle(id: genreTitleId)
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
    
    func configureGenreTitle(id: Int) -> String {
        
        switch id {
        case 28: return "액션"
        case 16: return "애니메이션"
        case 80: return "범죄"
        case 18: return "드라마"
        case 14: return "판타지"
        case 27: return "공포"
        case 9648: return "미스터리"
        case 878: return "SF"
        case 53: return "스릴러"
        case 37: return "서부"
        case 12: return "모험"
        case 35: return "코미디"
        case 99: return "다큐멘터리"
        case 10751: return "가족"
        case 36: return "역사"
        case 10402: return "음악"
        case 10749: return "로맨스"
        case 10770: return "TV 영화"
        case 10752: return "전쟁"
        default: return "장르 없음"
        }
        
    }
    
}
