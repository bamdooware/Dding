//
//  MainTabBarController.swift
//  Dding
//
//  Created by 이지은 on 11/23/24.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeVC = HomeViewController()
        let homeNavController = UINavigationController(rootViewController: homeVC)
        homeNavController.tabBarItem = UITabBarItem(title: "오늘 할 일", image: UIImage(systemName: "house"), tag: 0)

        let calendarVC = SubjectViewController()
        calendarVC.tabBarItem = UITabBarItem(title: "모아보기", image: UIImage(systemName: "square.grid.2x2"), tag: 1)

        let tabBarList = [homeNavController, calendarVC]
        viewControllers = tabBarList
    }
}
