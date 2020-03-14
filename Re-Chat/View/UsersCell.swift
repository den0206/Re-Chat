//
//  UsersCell.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/14.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class UserCell : UITableViewCell {
    
    var user : User? {
        didSet  {
            configure()
        }
    }
    
    //MARK: - Parts
    
    private lazy var profileImageView : UIImageView = {
        return UIImageView().profileImageView(setDimencion: 40)
    }()
    
    private let fullnameLabel : UILabel = {
        let label = UILabel()
        label.text = "Tese"
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    private let exTypeButton : UIButton = {
        let button = UIButton(type: .system)
        button.isEnabled = false
        button.setDimension(width: 30, height: 30)
        button.layer.cornerRadius = 30 / 2
        button.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        button.setTitle("男", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    
    
    //MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        addSubview(fullnameLabel)
        fullnameLabel.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 12)
        
        addSubview(exTypeButton)
        exTypeButton.centerY(inView: profileImageView)
        exTypeButton.anchor( right: rightAnchor, paddingRight: 20)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        print("Set User")
    }
}