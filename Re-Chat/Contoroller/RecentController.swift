//
//  RecentController.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/14.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class RecentController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavController()
    }
    
    private func configureNavController() {
        
        navigationItem.title = "Recent"

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleNewChat))
        navigationItem.rightBarButtonItem?.tintColor = .lightGray
        
    }
    
    //MARK: - Actions
    
    @objc func handleNewChat() {
        
        let usersVC = UINavigationController(rootViewController: UsersTableViewController())
        usersVC.modalPresentationStyle = .fullScreen
        present(usersVC, animated: true, completion: nil)
    }
}

