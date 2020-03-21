//
//  SideMenuHeader.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/21.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

protocol SIdeMenuHeaderDelegate : class {
    func tappedProfileImage(user : User)
}

class SideMenuHeader : UIView {
    
    private let user : User
    var delegate : SIdeMenuHeaderDelegate?
    
    //MARK: - Parts
    
    private lazy var profileImageView : UIImageView = {
        let iv = UIImageView().profileImageView(setDimencion: 64)
        iv.image = downloadImageFromData(picturedata: user.profileImage)
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4
        iv.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTappedImage))
        iv.addGestureRecognizer(tap)
        
        return iv
    }()
    
    private lazy var userNameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.text = user.fullname
        return label
    }()
    
    private lazy var emailLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.text = user.email
        return label
    }()
    
    
    
    init(user : User, frame : CGRect) {
        self.user = user
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(top : topAnchor, left: leftAnchor,paddongTop: 4,paddingLeft: 12)
        
        let labelStack = UIStackView(arrangedSubviews: [userNameLabel, emailLabel])
        labelStack.axis = .vertical
        labelStack.distribution = .fillEqually
        labelStack.spacing = 4
        
        addSubview(labelStack)
        labelStack.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 12)
        
        // under line view
        let underlineView = UIView()
        underlineView.backgroundColor = .white
        
        addSubview(underlineView)
        underlineView.anchor(left : leftAnchor, bottom: bottomAnchor,right: rightAnchor,paddingLeft: 8,paddingRight: 8,height: 2)
        
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func handleTappedImage() {
        delegate?.tappedProfileImage(user: user)
    }
}
