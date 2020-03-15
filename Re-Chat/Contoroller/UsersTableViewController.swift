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
    
    //MARK: - Parts
    
    // segment controller
    
    private lazy var userSegmentController : UISegmentedControl = {
        let sc = UISegmentedControl(items: ["All", "Man", "Woman"])
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(changeValue), for: .valueChanged)
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavController()
        configureTableView()
        
        // fetch All users
        fetchUsers(filter: nil)
    }
    
    private func configureNavController() {
        
        navigationItem.title = "Users"

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismiss))
        
    }
    
    private func configureTableView() {
        
        tableView.backgroundColor = .white
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        
        tableView.tableHeaderView = userSegmentController
        
        tableView.register(UserCell.self, forCellReuseIdentifier: reuserIdentifer)

        
    }
    
    private func fetchUsers(filter : String?) {
        
        UserSearvice.shared.filterUsers(filter: filter) { (users) in
            self.users = users
        }
      
    }
    //MARK: - Actions
 
    @objc func changeValue(sender : UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            fetchUsers(filter: nil)
        case 1 :
            fetchUsers(filter: kMAN)
        case 2 :
            fetchUsers(filter: kWOMAN)
        default:
            return
        }
        
    }
    
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
