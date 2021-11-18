//
//  TabBarVC.swift
//  ProjectData
//
//  Created by Igor Abovyan on 29.10.2021.
//

import UIKit

class TabBarVC: UITabBarController {
    
    
}

//MARK: life cycle
extension TabBarVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }
    
}


extension TabBarVC {
    
    private func config() {
        self.addControllers()
    }
    
    private func addControllers() {
        let homeVC = HomeVC.init()
        homeVC.tabBarItem = UITabBarItem.init(title: "Home", image: "house".getSymbol(size: 30, bold: .medium), tag: 0)
        let taskListVC = TaskListVC.init()
        taskListVC.tabBarItem = UITabBarItem.init(title: "List", image: "list.bullet".getSymbol(size: 30, bold: .medium), tag: 1)
        let navTaskList = UINavigationController.init(rootViewController: taskListVC)
        self.viewControllers = [homeVC, navTaskList]
        
    }
    
}


