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
        tabBar.tintColor = .starbuckGreen
        tabBar.unselectedItemTintColor = .grey145
        setUpTabBar()
    }
    
    private func setUpTabBar() {
        let homeViewController = UINavigationController(rootViewController: HomeViewController(viewModel: HomeViewModel()))
        homeViewController.tabBarItem.title = "Home"
        homeViewController.tabBarItem.image = UIImage(named: "ic_temp")
        
        let payViewController = UINavigationController(rootViewController: PayViewController(viewModel: PayViewModel()))
        payViewController.tabBarItem.title = "Pay"
        payViewController.tabBarItem.image = UIImage(named: "ic_temp")
        
        let orderViewController = OrderCategoryViewController(viewModel: OrderViewModel())
        let orderNavigationController = UINavigationController(rootViewController: orderViewController)
        orderNavigationController.tabBarItem.title = "Order"
        orderNavigationController.tabBarItem.image = UIImage(named: "ic_temp")
        
        viewControllers = [
            homeViewController, payViewController, orderNavigationController
        ]
    }
}
