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
    
    var user : User?
    
    var users = [User]() {
        didSet {
            tableView.reloadData()
        }
    }

    
    var filterUsers = [User]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    //MARK: - Parts
    
    // segment controller
    
    let searchController = UISearchController(searchResultsController: nil)
    
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
        configureSearchController()
        
        
        // fetch All users
        fetchUsers(filter: nil)
    }
    
    init(user : User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - configureb UI
    
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
    
    private func configureSearchController() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
  
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
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return filterUsers.count
        }
        
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var user : User
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuserIdentifer, for: indexPath) as! UserCell
        
        cell.delegate = self
        
        if searchController.isActive && searchController.searchBar.text != "" {
            user = filterUsers[indexPath.row]
        } else {
            user = users[indexPath.row]
        }
        
        cell.user = user
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        var user : User
        
        if searchController.isActive && searchController.searchBar.text != "" {
            user = filterUsers[indexPath.row]
        } else {
            user = users[indexPath.row]
        }
        
        guard let currentUser = User.currentUser() else {return}
        
        // when check if block
        let messageVC = MessageViewController()
        messageVC.chatRoomId = startPrivateChat(user1: currentUser, user2: user)
        messageVC.membersToPush = [User.currentId(), user.uid]
        messageVC.memberIds = [User.currentId(), user.uid]
        
        navigationController?.pushViewController(messageVC, animated: true)

    }
}

//MARK: - UserCell Delegate

extension UsersTableViewController : UserCellDelegate {
    func tappedProfileImage(_ cell: UserCell) {
        
        guard let user = cell.user else {return}
        
        // use navigation
        let profileVC = ProfileController(user: user)
        navigationController?.pushViewController(profileVC, animated: true)
        
    }
    
    
}

//MARK: - SearchResult Updating

extension UsersTableViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(searchText : String) {
        
        filterUsers = users.filter({ (user) -> Bool in
            return user.fullname.lowercased().contains(searchText.lowercased())
        })
        
        
    }

}
