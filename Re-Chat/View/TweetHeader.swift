//
//  TweetHeader.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/29.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class TweetHeader : UICollectionReusableView {
    
    var tweet : Tweet? {
        didSet {
            
            guard var tweet = tweet else {return}
            
            TweetService.shared.checkIfUserLikedTweet(tweet) { (didlike) in
                tweet.didLike = didlike
                self.configure()
            }
            
        }
    }
    
    //MARK: - Parts
    
    private lazy var profileImageView : UIImageView = {
        
        let iv = UIImageView().profileImageView(setDimencion: 48)
        
        return iv
    }()
    
    private let fullnameLabel : UILabel = {
        let label = UILabel()
        label.text = "Full name"
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    private let captionLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = "Caption"
        return label
    }()
    
    private let dateLabel : UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.text = "6:33 PM - 1/28/2020"
        return label
    }()
    
    private lazy var optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.setImage(UIImage(named: "down_arrow_24pt"), for: .normal)
        
        return button
    }()
    
    private let replyLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.text = "test Reply"
        return label
    }()
    
    private lazy var retweetsLabel = UILabel()
    private lazy var likesLabel = UILabel()
    
    private lazy var statsView : UIView = {
        let view = UIView()
        
        // separate Line
        
        let divider1 = UIView()
        divider1.backgroundColor = .systemGroupedBackground
        view.addSubview(divider1)
        divider1.anchor(top: view.topAnchor, left :view.leftAnchor, right: view.rightAnchor, paddingLeft: 8, height: 1.0)
        
        let stack = UIStackView(arrangedSubviews: [retweetsLabel, likesLabel])
        stack.axis = .horizontal
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.centerY(inView: view)
        stack.anchor(left : view.leftAnchor, paddingLeft: 16)
        
        
        // separate Line
        let divider2 = UIView()
        divider2.backgroundColor = .systemGroupedBackground
        view.addSubview(divider2)
        divider2.anchor( left :view.leftAnchor, bottom : view.bottomAnchor ,right: view.rightAnchor, paddingLeft: 8, height: 1.0)
        
        return view
    }()
    
    //MARK: - Buttons
    
    private lazy var commentButton : UIButton = {
        let button = createButton(withImage: #imageLiteral(resourceName: "comment"))
         return button
     }()
     
     private lazy var reTweetButton : UIButton = {
         let button = createButton(withImage: #imageLiteral(resourceName: "share"))
        return button
     }()
    
    private lazy var likeButton : UIButton = {
        let button = createButton(withImage: #imageLiteral(resourceName: "like"))
        return button
    }()
    
    private lazy var shareButton : UIButton = {
        let button = createButton(withImage: #imageLiteral(resourceName: "retweet"))
        return button
    }()
    
    //MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView, fullnameLabel])
        imageCaptionStack.spacing = 12
        
        let stack = UIStackView(arrangedSubviews: [replyLabel, imageCaptionStack])
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillProportionally
        
        addSubview( stack)
        stack.anchor(top : topAnchor, left: leftAnchor, paddongTop: 16,paddingLeft: 16)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: stack.bottomAnchor, left: leftAnchor, right: rightAnchor,
                                   paddongTop : 12, paddingLeft: 16, paddingRight: 16)
         
         addSubview(dateLabel)
         dateLabel.anchor(top : captionLabel.bottomAnchor, left : leftAnchor, paddongTop : 20, paddingLeft : 16)
         
         addSubview(optionsButton)
         optionsButton.centerY(inView: stack)
         optionsButton.anchor(right : rightAnchor, paddingLeft: 8)
         
         addSubview(statsView)
         statsView.anchor(top : dateLabel.bottomAnchor, left: leftAnchor, right: rightAnchor,paddongTop : 12, height: 40)
        
        let buttonStack = UIStackView(arrangedSubviews: [commentButton, reTweetButton,likeButton, shareButton])
        
        buttonStack.spacing = 72
        addSubview(buttonStack)
        buttonStack.centerX(inView: self)
        buttonStack.anchor(top : statsView.bottomAnchor, paddongTop : 16)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        guard let tweet = tweet else {return}
        let vm = TweetViewModel(tweet: tweet)
        
        captionLabel.text = tweet.caption
        fullnameLabel.text = vm.fullnameText
        profileImageView.image = downloadImageFromData(picturedata: vm.profileImageString)
        dateLabel.text = vm.headerTimeStamp
        
        replyLabel.isHidden = true
        
        retweetsLabel.attributedText = vm.retweetAttributedString
        likesLabel.attributedText = vm.likesAttributedString
        
        likeButton.tintColor = vm.likeButtonTintColor
        likeButton.setImage(vm.likeButtonImage, for: .normal)
    }
    
    private func createButton(withImage image: UIImage) -> UIButton{
        
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .darkGray
        button.setDimension(width: 20, height: 20)
        return button
        
    }
}
