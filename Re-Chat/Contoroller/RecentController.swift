//
//  RecentController.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/14.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import FirebaseFirestore

private let reuseIdentifer = "RecentCell"

class RecentController : UIViewController {
    
    var currentUser : User?
    
    var recentChats : [Dictionary<String, Any>] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var filterChats : [Dictionary<String, Any>] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var recentListner : ListenerRegistration?
    
    //MARK: - Psrts
    
    var tableView = UITableView()
    
    private let searchOptionView : UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        // underLine
        
        let underline = UIView()
        underline.backgroundColor = .lightGray
        
        view.addSubview(underline)
        underline.anchor(left :view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, height: 1)
        return view
    }()
    
    private let searchTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Search User name.."
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        tf.layer.borderColor = UIColor.lightGray.cgColor.copy(alpha: 0.9)
        tf.layer.borderWidth = 0.3
        tf.addTarget(self, action: #selector(valitation), for: .editingChanged)
        
        // padding
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: tf.frame.height))
        tf.leftView = paddingView
        tf.leftViewMode = .always
        return tf
    }()
    
    private let searchButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .lightGray
        button.setTitle("Search", for: .normal)
        button.isEnabled = false
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(searchTapped(_ :)), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        
        return button
    }()
    
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
    
    let searchController = UISearchController(searchResultsController: nil)
    
   
    
    //MARK: - Life Cycle
    
    deinit {
        recentListner?.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuretableView()
        configureUI()
        
        fetchRecent()
        
        
        
    }
    
    //MARK: - configureUI sec
    
    private func configuretableView() {
        
        
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        tableView.separatorStyle = .none

        tableView.tableFooterView = UIView()
        tableView.register(RecentCell.self, forCellReuseIdentifier: reuseIdentifer)
        
        // search Controller
        searchController.searchResultsUpdater = self
        
        searchController.searchBar.searchTextField.text = searchTextField.text
        
        
       
    }
    
    
    
    
    
    private func configureUI() {
        navigationItem.title = "Recent"
        
        view.backgroundColor = .white
        
        view.addSubview(searchOptionView)
        searchOptionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor,width: view.frame.size.width,height: 75)
        
        searchOptionView.addSubview(searchTextField)
        searchTextField.centerY(inView: searchOptionView)
        searchTextField.delegate = self
        searchTextField.anchor(left : searchOptionView.leftAnchor,  paddingLeft: 16,height: 36)
        
        searchOptionView.addSubview(searchButton)
        searchButton.centerY(inView: searchTextField)
        searchButton.anchor(left : searchTextField.rightAnchor,right: searchOptionView.rightAnchor,paddingLeft: 8,paddingRight: 8, width: 70, height: 30)
        
        view.addSubview(tableView)
        tableView.anchor(top: searchOptionView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)

        view.addSubview(newChatButton)
        newChatButton.anchor(bottom : view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,paddiongBottom: 64, paddingRight: 16)
        
        
        
    }
    
    //MARK: - API
    
    func fetchRecent() {
        guard let uid = currentUser?.uid else { return}
        
        recentListner = MessageSearvice.shared.fetchRecent(userId: uid) { (recents) in
            self.recentChats = recents
        }
 
    }
    
    
    
    //MARK: - Actions
    

    @objc func handleNewChat(_ sender : UIButton) {
        guard let user = self.currentUser else {return}
        let usersVC = UsersTableViewController(user: user)
        
        let nav = UINavigationController(rootViewController: usersVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
        
    }
    
    @objc func searchTapped(_ sender : UIButton) {
        
        searchController.searchBar.searchTextField.text = searchTextField.text
        print(searchController.searchBar.searchTextField.text)
        
    }
    
    
    
    @objc func valitation() {
        guard searchTextField.hasText else {
            searchButton.isEnabled = false
            searchButton.backgroundColor = .lightGray
            searchButton.setTitleColor(.white, for: .normal)
            return
        }
        searchButton.isEnabled = true
        searchButton.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        
    }
    
    
}

//MARK: - UItableview Delegate

extension RecentController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchTextField.text != "" {
            return filterChats.count
        } else {
            return recentChats.count
        }
        
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! RecentCell
        
        var recent : Dictionary<String, Any>
        
        if searchTextField.text != "" {
            recent = filterChats[indexPath.row]
        } else {
            recent = recentChats[indexPath.row]
        }
        
    
        cell.generateCell(recent: recent, indexPath: indexPath)
        
        return cell
    }
    
    
}

extension RecentController : UISearchResultsUpdating, UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        searchController.searchBar.searchTextField.text = searchTextField.text
        filterContentForText(searchText: searchController.searchBar.searchTextField.text!)
        return true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForText(searchText: searchController.searchBar.text!)
    }
    
    func filterContentForText(searchText : String, scope : String = "All") {
        
        filterChats = recentChats.filter({ (recentChat) -> Bool in
            return (recentChat[kWITHUSERFULLNAME] as! String).lowercased().contains(searchText.lowercased())
        })
        
    }
    
    
}
