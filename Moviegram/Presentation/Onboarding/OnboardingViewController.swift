//
//  OnboardingViewController.swift
//  Moviegram
//
//  Created by 이빈 on 1/24/25.
//

import UIKit

// MARK: - 온보딩 ViewController
final class OnboardingViewController: BaseViewController<OnboardingView> {
    
    deinit {
        print("OnboardingViewController Deinit")
    }
    
    override func configureGesture() {
        mainView.startButton.addTarget(
            self,
            action: #selector(startButtonTapped),
            for: .touchUpInside
        )
    }

    @objc private func startButtonTapped() {
        let vc = ProfileSettingViewController()
        vc.viewModel.input.editMode.value = false
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
