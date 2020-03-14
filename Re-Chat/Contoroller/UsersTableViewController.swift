//
//  UsersTableViewController.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/14.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

private let reuserIdentifer = "UserCell"

class UsersTableViewController : UITableViewController {
    
    var users = [User]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavController()
        configureTableView()
        
        fetchUsers()
        
    }
    
    private func configureNavController() {
        
        navigationItem.title = "Users"

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismiss))
        
    }
    
    private func configureTableView() {
        
        tableView.backgroundColor = .white
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        
        tableView.register(UserCell.self, forCellReuseIdentifier: reuserIdentifer)

        
    }
    
    private func fetchUsers() {
        UserSearvice.shared.fetchUsers { (users) in
            self.users = users
        }
    }
    //MARK: - Actions
    
    @objc func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - tableview Delegate

extension UsersTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuserIdentifer, for: indexPath) as! UserCell
        
        cell.user = users[indexPath.row]
        
        return cell
    }
}
