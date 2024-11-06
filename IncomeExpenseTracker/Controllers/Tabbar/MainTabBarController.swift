//
//  MainTabBarController.swift
//  IncomeExpenseTracker
//
//  Created by Bayram Yeleç on 4.11.2024.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .systemGray6
        tabBar.unselectedItemTintColor = .systemRed.withAlphaComponent(0.3)
    }
    

    

}
