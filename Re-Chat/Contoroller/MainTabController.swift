//
//  MainTabController.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/11.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import Firebase

class MaintabController : UITabBarController {
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backGroundColor
        
        checkUserIsLogin()
    }
    
    //MARK: - UI
    
    func configureTabControllers() {
        let feedVC = ContainerController()
        let nav1 = templetaNavigationViewController(image: #imageLiteral(resourceName: "home_unselected"), rootiViewController: feedVC)
        
        viewControllers = [nav1]
    }
    
    func checkUserIsLogin() {
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginViewController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        } else {
            
            configureTabControllers()

        }
    }
    

    
    
}

 //MARK: - Helpers

extension MaintabController {
    
   
    
    private func templetaNavigationViewController(image : UIImage?, rootiViewController : UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: rootiViewController)
        nav.tabBarItem.image  = image
        nav.navigationBar.barTintColor = .white
        
        return nav
        
    }
    
}
