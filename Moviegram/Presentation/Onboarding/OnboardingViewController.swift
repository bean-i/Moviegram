//
//  OnboardingViewController.swift
//  Moviegram
//
//  Created by 이빈 on 1/24/25.
//

import UIKit

// MARK: - 온보딩 ViewController
final class OnboardingViewController: BaseViewController<OnboardingView> {
    
    override func configureGesture() {
        mainView.startButton.addTarget(
            self,
            action: #selector(startButtonTapped),
            for: .touchUpInside
        )
    }

    @objc private func startButtonTapped() {
        let vc = ProfileSettingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
