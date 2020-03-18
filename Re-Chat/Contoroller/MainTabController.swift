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
    
    var user : User? {
        didSet {
            guard let nav = viewControllers?[0] as? UINavigationController else {return}
            guard let cont = nav.viewControllers.first as? ContainerController else {return}
            
            cont.user = user
        }
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        view.backgroundColor = .backGroundColor
        
        checkUserIsLogin()
    }
    
    //MARK: - UI
    
  
    
    func checkUserIsLogin() {
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginViewController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
            

        } else {
            print("Exist")
            configureTabControllers()
            fetchCurrentUser()
        }
    }
    
    func configureTabControllers() {
        let feedVC = ContainerController()
        let nav1 = templetaNavigationViewController(image: #imageLiteral(resourceName: "home_unselected"), rootiViewController: feedVC)
        
        let recentVC = RecentController()
        let nav2 = templetaNavigationViewController(image: #imageLiteral(resourceName: "comment"), rootiViewController: recentVC)
        
        let newsVC = NewsViewController()
        newsVC.tabBarItem.image = #imageLiteral(resourceName: "baseline_menu_black_36dp")
        
        let weatherVC =  WeatherController()
        weatherVC.tabBarItem.image = #imageLiteral(resourceName: "humidity")
    
        
        
        
        
        viewControllers = [nav1, nav2, newsVC, weatherVC]
    }
    
    func fetchCurrentUser() {
        guard let currentuid = Auth.auth().currentUser?.uid else {return}
        
        AuthSearvice.shared.fetchUser(uid: currentuid) { (user) in
            self.user = user
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
