//
//  MainTabController.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/11.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class MaintabController : UITabBarController {
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backGroundColor
        
        configureTabControllers()
    }
    
    //MARK: - UI
    
    func configureTabControllers() {
        let feedVC = ContainerController()
        let nav1 = templetaNavigationViewController(image: #imageLiteral(resourceName: "home_unselected"), rootiViewController: feedVC)
        
        viewControllers = [nav1]
    }
    
    //MARK: - Helpers
    
    private func templetaNavigationViewController(image : UIImage?, rootiViewController : UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: rootiViewController)
        nav.tabBarItem.image  = image
        nav.navigationBar.barTintColor = .white
        
        return nav
        
    }
    
    
}
