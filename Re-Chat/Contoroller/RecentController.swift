//
//  RecentController.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/14.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

private let reuseIdentifer = "RecentCell"

class RecentController : UIViewController {
    
     var currentUser : User?
    
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
        tf.placeholder = "Search Recent"
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        tf.layer.borderColor = UIColor.lightGray.cgColor.copy(alpha: 0.9)
        tf.layer.borderWidth = 0.3
        
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
        button.setTitleColor(.white, for: .normal)
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
    
   
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuretableView()
        
        configureNavController()
        
        
    }
    
    private func configuretableView() {
        
        
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        
        tableView.tableFooterView = UIView()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifer)
    }
    
    
    
    
    
    private func configureNavController() {
        navigationItem.title = "Recent"
        
        view.backgroundColor = .white
        
        view.addSubview(searchOptionView)
        searchOptionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor,width: view.frame.size.width,height: 75)
        
        searchOptionView.addSubview(searchTextField)
        searchTextField.centerY(inView: searchOptionView)
        searchTextField.anchor(left : searchOptionView.leftAnchor,  paddingLeft: 16,height: 36)
        
        searchOptionView.addSubview(searchButton)
        searchButton.centerY(inView: searchTextField)
        searchButton.anchor(left : searchTextField.rightAnchor,right: searchOptionView.rightAnchor,paddingLeft: 8,paddingRight: 8, width: 70, height: 30)
        
        view.addSubview(tableView)
        tableView.anchor(top: searchOptionView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)

        view.addSubview(newChatButton)
        newChatButton.anchor(bottom : view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,paddiongBottom: 64, paddingRight: 16)
        
        
        
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

//MARK: - UItableview Delegate

extension RecentController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath)
        
        return cell
    }
    
    
}
