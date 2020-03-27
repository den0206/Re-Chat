//
//  ContainerController.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/11.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import FirebaseAuth

class ContainerController : UIViewController {
    
    private let feedController = FeedController()
    private var sideMenuController : SideMenuController!
    
    private var isExpand = false
    
    private let blackView = UIView()
    
    // black view X
    private lazy var xOrigin = self.view.frame.width - 80
    
    var user : User? {
        didSet {
            configureFeedController()
            configureMenuController()

            configureNavigationBarButton()
        }
    }
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
    }
    
   
    override var prefersStatusBarHidden: Bool {
        return isExpand
    }
    
    private func configureNavigationBarButton() {
        
        navigationItem.title = "Feed"
        
        // right button

        let sideMenuButton : UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "baseline_menu_black_36dp"), style: .plain, target: self, action: #selector(handleMenuToggle))
        sideMenuButton.tintColor = .black
        
        // multiple Button
        navigationItem.leftBarButtonItem = sideMenuButton
        
        // left button
        
        let profileImageView = UIImageView().profileImageView(setDimencion: 27)
      
        
        imageFromData(pictureData: user!.profileImage) { (avatar) in
            profileImageView.image = avatar
        }
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showProfileVC)))
        
        let profileImageButton = UIBarButtonItem(customView: profileImageView)
        
        let rightButton = UIBarButtonItem(image: #imageLiteral(resourceName: "humidity"), style: .plain, target: self, action: #selector(showWeatherVC(_ :)))
        rightButton.tintColor = .lightGray
        
        navigationItem.rightBarButtonItems = [rightButton, profileImageButton]
        
        
        
    }
    
   
    
    
    func configureFeedController() {
        
        guard let user = user else {
            print("NO USER")
            return}
        
        tabBarController?.tabBar.isHidden = false
        
        addChild(feedController)
        feedController.didMove(toParent: self)
        feedController.delegate = self
        view.addSubview(feedController.view)
        feedController.user = user
    }
    
    func configureMenuController() {
        guard let user = user else {return}
        
        sideMenuController = SideMenuController(user: user)
        addChild(sideMenuController)
        sideMenuController.delegate = self
        view.insertSubview(sideMenuController.view, at: 0)
        
        // black view
        configureBlackView()
        
    }
    
    private func configureBlackView() {
        blackView.frame = CGRect(x: self.xOrigin, y: 0, width: 80, height: view.frame.height)
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        blackView.alpha = 0
        view.addSubview(blackView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissMenu))
        blackView.addGestureRecognizer(tap)
    }
    
    
    func animateMenu(shouldExpand : Bool, completion :((Bool) -> Void)? = nil) {
        
        if shouldExpand {
            view.backgroundColor = .darkGray
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.feedController.view.frame.origin.x = self.xOrigin
                
                self.tabBarController?.tabBar.isHidden = true
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                
                self.blackView.alpha = 1
            }, completion: nil)
            
        } else {
            // return
            
            view.backgroundColor = .white
            self.blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.feedController.view.frame.origin.x = 0
                
                self.tabBarController?.tabBar.isHidden = false
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            }, completion: completion)
        }
        
    }
    
    //MARK: - Actions
    
    @objc func showWeatherVC(_ sender : UIBarButtonItem) {
        let weatherVC = WeatherViewController()
        
        if #available(iOS 13.0, *) {
            weatherVC.modalPresentationStyle = .fullScreen
        }
        present(weatherVC, animated: true, completion: nil)
    }
    
    @objc func showProfileVC() {
        guard let user = user else {return}
        let profileVC = ProfileController(user: user)
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    
    @objc func dismissMenu() {
        isExpand = false
        animateMenu(shouldExpand: false)
    }
    

    
}

extension ContainerController : FeedControllerDelegate {
    
    // add @objc for user self
    
    @objc func handleMenuToggle() {
        isExpand.toggle()
        
        animateMenu(shouldExpand: isExpand)
    }
    
    
    
}

extension ContainerController : SideMenuControllerDelegate {
    
    func userFromHeaderView(user: User) {
        let profileVC = ProfileController(user: user)
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    func didSelect(option: MenuOptions) {
        
        switch option {
        case .logout:
            let actionSheet = UIAlertController(title: "Logout", message: nil, preferredStyle: .actionSheet)
            
            actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
                self.logOut()
            }))
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            actionSheet.addAction(cancel)
            
            present(actionSheet, animated: true, completion: nil)
            
            
        }
    }
    
    func logOut() {
        
        UserDefaults.standard.removeObject(forKey: kCURRENTUSER)
        UserDefaults.standard.synchronize()
        
        do {
            try Auth.auth().signOut()
            let nav = UINavigationController(rootViewController: LoginViewController())
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        } catch let error {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
        
    }
    
    
}



