//
//  OnboardingView.swift
//  Moviegram
//
//  Created by 이빈 on 1/24/25.
//

import UIKit
import SnapKit

final class OnboardingView: BaseView {
    
    private let mainImageView = UIImageView()
    private let mainLabel = UILabel()
    private let subLabel = UILabel()
    let startButton = UIButton()
    
    override func configureHierarchy() {
        addSubViews(
            mainImageView,
            mainLabel,
            subLabel,
            startButton
        )
    }
    
    override func configureLayout() {
        mainImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(500)
        }
        
        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        startButton.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(15)
            make.height.equalTo(44)
        }
    }
    
    override func configureView() {
        mainImageView.image = .onboarding
        mainImageView.contentMode = .scaleAspectFill
        
        mainLabel.text = "Onboarding"
        mainLabel.textColor = .white
        mainLabel.font = .italicSystemFont(ofSize: 30)
        mainLabel.textAlignment = .center
        
        subLabel.text = "당신만의 영화 세상,\nMoviegram을 시작해 보세요."
        subLabel.textColor = .white
        subLabel.font = .Font.large.of(weight: .medium)
        subLabel.textAlignment = .center
        subLabel.numberOfLines = 0
        
        startButton.setTitle("시작하기", for: .normal)
        startButton.titleLabel?.font = .Font.large.of(weight: .heavy)
        startButton.setTitleColor(.point, for: .normal)
        startButton.backgroundColor = .black
        startButton.layer.cornerRadius = 20
        startButton.layer.borderWidth = 2
        startButton.layer.borderColor = UIColor.point.cgColor
    }
    
}
