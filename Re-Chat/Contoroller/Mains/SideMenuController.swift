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
}

class SideMenuController : UITableViewController {
    
    var delegate : SideMenuControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    private func configureTableView() {
        view.backgroundColor = .black
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        
        tableView.isScrollEnabled = false
        tableView.rowHeight = 60
        
        
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
        
        cell.backgroundColor = .black
        cell.textLabel?.textColor = .white
        
        let selectedView = UIView()
        selectedView.backgroundColor = .backGroundColor
        cell.selectedBackgroundView = selectedView
    }
}


