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
            searchRecents(searchText: "")
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
    
    private var searchBar : UISearchBar!
    var isBarShow = true
    
    var tableView = UITableView()
    
    let searchBarHeight: CGFloat = 44
    var topSafeAreaHeight: CGFloat = 0

    
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
        
        configureSearchBar()
        configuretableView()
        configureUI()
        
        fetchRecent()
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topSafeAreaHeight = view.safeAreaInsets.top
        
    }
    
    //MARK: - configureUI sec
    
    private func configureSearchBar() {
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar(_ :)))
        navigationItem.rightBarButtonItem = searchButton
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: searchBarHeight)
        searchBar.showsCancelButton = true
        
    }
    
    private func configuretableView() {
        
        
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        tableView.separatorStyle = .none
        tableView.frame = view.frame
//        tableView.contentOffset = CGPoint(x: 0, y: searchBarHeight)
        tableView.tableHeaderView = searchBar
        // default open
        tableView.contentOffset = CGPoint(x: 0, y: -self.topSafeAreaHeight)
        

        tableView.tableFooterView = UIView()
        tableView.register(RecentCell.self, forCellReuseIdentifier: reuseIdentifer)
        
        view.addSubview(tableView)
        
       
        
       
    }
    
    

    
    private func configureUI() {
        navigationItem.title = "Recent"
    
        
        view.backgroundColor = .white
        

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
    
    @objc func showSearchBar(_ sender : UIBarButtonItem) {
        
        if isBarShow {
            
            // hide
            UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveLinear], animations: {
                self.tableView.contentOffset = CGPoint(x: 0, y: -self.searchBarHeight)
            }, completion: nil)
            
        } else {
            UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveLinear], animations: {
                self.tableView.contentOffset = CGPoint(x: 0, y: -self.topSafeAreaHeight)
            }, completion: nil)
        }
        
        isBarShow.toggle()
        searchBar.text = ""
        // reset
        searchRecents(searchText: "")
        
    }
    
    
    
}

//MARK: - UItableview Delegate

extension RecentController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filterChats.count
        
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! RecentCell
        
        var recent : Dictionary<String, Any>
        recent = filterChats[indexPath.row]
      
    
        cell.generateCell(recent: recent, indexPath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let recent = filterChats[indexPath.row]
        
        
        let messageVC = MessageViewController()
        messageVC.chatRoomId = (recent[kCHATROOMID] as? String)!
        messageVC.memberIds = (recent[kMEMBERS] as? [String])!
        messageVC.membersToPush = (recent[kMEMBERSTOPUSH] as? [String])!
        
        navigationController?.pushViewController(messageVC, animated: true)
    }
    
    
}

//MARK: - Search Bar Delegate

extension RecentController : UISearchBarDelegate {
    
    func searchRecents(searchText: String) {
        
        if searchText != "" {
            filterChats = recentChats.filter({ (dic) -> Bool in
                let withUserName = dic[kWITHUSERFULLNAME] as! String
                print(withUserName)
                return withUserName.lowercased().contains(searchText.lowercased())
            })
        } else {
            // return no filter
            filterChats = recentChats
        }
 
    }
    
    // delegate method
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchRecents(searchText: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
          searchBar.text = ""
          view.endEditing(true)
          filterChats = recentChats
          
      }

      // Searchボタンが押されると呼ばれる
      func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
          view.endEditing(true)
          //検索する
          searchRecents(searchText: searchBar.text! as String)
      }
}
