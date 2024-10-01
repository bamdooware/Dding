//
//  ViewController.swift
//  Dding
//
//  Created by 이지은 on 9/30/24.
//

import UIKit

class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "오늘 할 일", image: UIImage(systemName: "house"), tag: 0)

        let calendarVC = SubjectViewController()
        calendarVC.tabBarItem = UITabBarItem(title: "전체보기", image: UIImage(systemName: "square.grid.2x2"), tag: 1)

        let tabBarList = [homeVC, calendarVC]
        viewControllers = tabBarList
    }


}

