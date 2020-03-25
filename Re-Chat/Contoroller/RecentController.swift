//
//  RecentController.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/14.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class RecentController : UIViewController {
    
    //MARK: - Psrts
    
    let newChatButton : UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        button.setImage(#imageLiteral(resourceName: "comment"), for: .normal)
        button.addTarget(self, action: #selector(handleNewChat(_ :)), for: .touchUpInside)
        button.setDimension(width: 56, height: 56)
        button.layer.cornerRadius = 56 / 2
        return button
    }()
    
    var currentUser : User? 
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavController()
    }
    
    
    
    private func configureNavController() {
        
        view.backgroundColor = .white
        view.addSubview(newChatButton)
        newChatButton.anchor(bottom : view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,paddiongBottom: 64, paddingRight: 16)
       
        
        navigationItem.title = "Recent"
        
        
    }
    
    //MARK: - Actions
    
    @objc func handleNewChat(_ sender : UIButton) {
        guard let user = self.currentUser else {return}
        let usersVC = UsersTableViewController(user: user)
        
        let nav = UINavigationController(rootViewController: usersVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
}

