//
//  TabBarController.swift
//  Moviegram
//
//  Created by 이빈 on 1/24/25.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureTabBarController()
        configureTabBarAppearance()
    }
    
    func configureTabBarController() {
        let firstVC = MainViewController()
        firstVC.tabBarItem.title = "CINEMA"
        firstVC.tabBarItem.image = UIImage(systemName: "popcorn")
        let firstNav = UINavigationController(rootViewController: firstVC)
        
        let secondVC = UpcomingViewController()
        secondVC.tabBarItem.title = "UPCOMING"
        secondVC.tabBarItem.image = UIImage(systemName: "film")
        let secondNav = UINavigationController(rootViewController: secondVC)
        
        let thirdVC = SettingViewController()
        thirdVC.tabBarItem.title = "PROFILE"
        thirdVC.tabBarItem.image = UIImage(systemName: "person.crop.circle")
        let thirdNav = UINavigationController(rootViewController: thirdVC)
        
        setViewControllers([firstNav, secondNav, thirdNav], animated: true)
    }

    func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .black
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.point]
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = .point
    }
}
