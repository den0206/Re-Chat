//
//  ContainerController.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/11.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class ContainerController : UIViewController {
    
    private let feedController = FeedController()
    private var sideMenuController : SideMenuController!
    
    private var isExpand = false
    
    private let blackView = UIView()
    
    // black view X
    private lazy var xOrigin = self.view.frame.width - 80
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFeedController()
        configureMenuController()
        
        configureLeftBarButton()
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return isExpand
    }
    
    private func configureLeftBarButton() {
        
        navigationItem.title = "Feed"
        
        let profileImageView = UIImageView()
        profileImageView.setDimension(width: 32, height: 32)
        profileImageView.backgroundColor = .lightGray
        profileImageView.layer.cornerRadius = 32 / 2
        profileImageView.layer.masksToBounds = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
        
    }
    
    
    private func configureFeedController() {
  
        addChild(feedController)
        feedController.didMove(toParent: self)
        feedController.delegate = self
        view.addSubview(feedController.view)
    }
    
    func configureMenuController() {
        sideMenuController = SideMenuController()
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
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.feedController.view.frame.origin.x = self.xOrigin
                
                self.tabBarController?.tabBar.isHidden = true
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                
                self.blackView.alpha = 1
            }, completion: nil)
            
        } else {
            self.blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.feedController.view.frame.origin.x = 0
                
                self.tabBarController?.tabBar.isHidden = false
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            }, completion: completion)
        }
        
    }
    
    //MARK: - Actions
    
    @objc func dismissMenu() {
        isExpand = false
        animateMenu(shouldExpand: false)
    }
    
    
    
    
}

extension ContainerController : FeedControllerDelegate {
    func handleMenuToggle() {
        isExpand.toggle()
        
        animateMenu(shouldExpand: isExpand)
    }
    
    
}

extension ContainerController : SideMenuControllerDelegate {
    func didSelect(option: MenuOptions) {
        
        switch option {
        case .logout:
            print("Logout")
        }
    }

    
}

