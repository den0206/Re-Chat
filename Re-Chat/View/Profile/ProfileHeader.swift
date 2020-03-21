//
//  ProfileHeader.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/21.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

protocol ProfileHeaderDelegate : class {
    func backAction()
}

class ProfileHeader : UICollectionReusableView {
    
    var user : User? {
        didSet {
            configure()
        }
    }
    var delegate : ProfileHeaderDelegate?
    
    //MARK: - Parts
    
    private lazy var containerView : UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        
        view.addSubview(backButton)
        backButton.anchor(top : view.topAnchor, left: view.leftAnchor, paddongTop:  42, paddingLeft: 16)
        backButton.setDimension(width: 30, height: 30)
        
        return view
    }()
    
    private lazy var backButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_arrow_back_white_24dp").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        return button
    }()
    
    private let profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.backgroundColor = .darkGray
        iv.layer.borderColor = UIColor.white.cgColor
        iv.setDimension(width: 80, height: 80)
        iv.layer.cornerRadius = 80 / 2
        iv.layer.borderWidth = 4
        return iv
    }()
    
    private lazy var editProfileFollowButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.borderColor = UIColor.backGroundColor.cgColor
        button.layer.borderWidth = 1.25
        button.setTitleColor(.backGroundColor, for: .normal)
        button.setDimension(width: 100, height: 32)
        button.layer.cornerRadius = 36 / 2
//        button.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)
        return button
    }()
     
     private let fullnameLabel: UILabel = {
         let label = UILabel()
         label.font = UIFont.boldSystemFont(ofSize: 20)
         return label
     }()
     
     private let usernameLabel: UILabel = {
         let label = UILabel()
         label.font = UIFont.systemFont(ofSize: 16)
         label.textColor = .lightGray

         return label
     }()
     
     private let bioLabel: UILabel = {
         let label = UILabel()
         label.font = UIFont.systemFont(ofSize: 16)
         label.numberOfLines = 3
         label.text = "Biooo"

         return label
     }()
    
    private lazy var followingLabel : UILabel = {
        let label = UILabel()
        label.text = "Following"
        return label
    }()
    
    private lazy var followersLabel : UILabel = {
        let label = UILabel()
        label.text = "Followers"

        return label
    }()
    
    private let filterView = ProfileFilterView()
     
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(containerView)
        containerView.anchor(top : topAnchor, left:  leftAnchor, right: rightAnchor, height: 108)
        
        addSubview(profileImageView)
        profileImageView.anchor(top : containerView.bottomAnchor, left:  leftAnchor, paddongTop: -24,paddingLeft: 8)
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top : containerView.bottomAnchor, right: rightAnchor, paddongTop: 12, paddingRight: 12)
        
        let detailStack = UIStackView(arrangedSubviews: [fullnameLabel,usernameLabel,bioLabel])
        detailStack.axis = .vertical
        detailStack.distribution = .fillProportionally
        detailStack.spacing = 4
        
        addSubview(detailStack)
        detailStack.anchor(top : profileImageView.bottomAnchor,left: leftAnchor,right: rightAnchor,paddongTop: 8,paddingLeft: 12,paddingRight: 12)
        
        let followStack = UIStackView(arrangedSubviews: [followingLabel, followersLabel])
        followStack.axis = .horizontal
        followStack.distribution = .fillEqually
        followStack.spacing = 8
        
        addSubview(followStack)
        followStack.anchor(top : detailStack.bottomAnchor,left :leftAnchor,paddongTop: 8,paddingLeft: 12)
        
        addSubview(filterView)
        filterView.anchor(left : leftAnchor, bottom: bottomAnchor, right: rightAnchor,height: 50)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - configfure
    
    func configure() {
        guard let user = user else {return}
        let vm = ProfileHeaderViewModel(user: user)
        
        usernameLabel.text = vm.userNameText
        
        profileImageView.image = downloadImageFromData(picturedata: user.profileImage)
        
    }
    
    //MARK: - delegate Action
    
    @objc func backAction() {
        delegate?.backAction()
    }
    
    @objc func handleEditProfileFollow() {
        print("handle follow")
    }
}
