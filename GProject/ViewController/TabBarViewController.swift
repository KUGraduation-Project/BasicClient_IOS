//
//  TabBarViewController.swift
//  GProject
//
//  Created by 서정 on 2022/04/29.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = .white
        
        createBarItems()
    }
    
    func createBarItems() {
        viewControllers = [
            createNavController(for: ProjectListViewController(),
                                   title: "My",
                                image: (UIImage(named: "Home")?.resize(newWidth: 25))!),
            createNavController(for: NeighborListViewController(),
                                   title: "Neighbor",
                                image: (UIImage(named: "Neighbor")?.resize(newWidth: 25))!)
           
        ]
    }
    
    func createNavController(for rootViewController: UIViewController,
                             title: String,
                             image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }

}
