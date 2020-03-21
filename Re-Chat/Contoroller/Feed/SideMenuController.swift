//
//  SideMenuController.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/11.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

private let reuserIdentifer = "MenuCell"

enum MenuOptions : Int, CaseIterable, CustomStringConvertible {
    case logout
    
    var description: String {
        switch self {
            
        case .logout:
            return "Log Out"
        }
    }
    
}

protocol SideMenuControllerDelegate {
    func didSelect(option : MenuOptions)
    func userFromHeaderView(user : User)
}

//MARK: - Controller

class SideMenuController : UITableViewController {

    private let user : User
    
    var delegate : SideMenuControllerDelegate?
    
    //MARK: - Parts(side Menu)
    
    private lazy var sideMenuHeader : UIView = {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 80, height: 140)
        let view = SideMenuHeader(user: user, frame: frame)
        view.delegate = self
        
        return view
        
    }()
    
    init(user : User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    private func configureTableView() {
        
        tableView.backgroundColor = .darkGray
        tableView.separatorStyle = .none
        
        tableView.isScrollEnabled = false
        tableView.rowHeight = 60
        
        tableView.tableHeaderView = sideMenuHeader
        
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuserIdentifer)
    }
    
}

//MARK: - TableView delegate

extension SideMenuController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuserIdentifer, for: indexPath)
        
        guard let option = MenuOptions(rawValue: indexPath.row) else {return UITableViewCell()}
        cell.textLabel?.text = option.description
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let option = MenuOptions(rawValue: indexPath.row) else {return}
        
        delegate?.didSelect(option: option)
        
    }
    
    // cell color
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.backgroundColor = .darkGray
        cell.textLabel?.textColor = .white
        
        if cell.textLabel?.text == "Log Out" {
             cell.textLabel?.textColor = .red
        }
        
        let selectedView = UIView()
        selectedView.backgroundColor = .backGroundColor
        cell.selectedBackgroundView = selectedView
    }
}

extension SideMenuController : SIdeMenuHeaderDelegate {
    
    func tappedProfileImage(user: User) {
        delegate?.userFromHeaderView(user: user)
    }
    
    
    
}


