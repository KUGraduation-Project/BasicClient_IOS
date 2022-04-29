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
        
        createBarItems()
    }
    
    func createBarItems() {
        viewControllers = [
            createNavController(for: ProjectListViewController(),
                                   title: "My",
                                image: UIImage(systemName: "heart.fill")!),
            createNavController(for: NeighborListViewController(),
                                   title: "Neighbor",
                                   image: UIImage(systemName: "heart.fill")!)
           
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
