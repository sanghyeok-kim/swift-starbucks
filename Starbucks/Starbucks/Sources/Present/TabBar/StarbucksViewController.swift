//
//  StarbucksTabBarViewController.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/09.
//

import UIKit

class StarbucksViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tabBar.tintColor = .green1
        tabBar.unselectedItemTintColor = .grey145
        setUpTabBar()
    }
    
    private func setUpTabBar() {
        let homeViewController = HomeViewController(viewModel: HomeViewModel())
        homeViewController.tabBarItem.title = "Home"
        homeViewController.tabBarItem.image = UIImage(named: "ic_temp")
        
        let payViewController = PayViewController()
        payViewController.tabBarItem.title = "Pay"
        payViewController.tabBarItem.image = UIImage(named: "ic_temp")
        
        viewControllers = [
            homeViewController, payViewController
        ]
    }
}
