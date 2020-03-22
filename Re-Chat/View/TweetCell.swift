//
//  TweetCell.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/22.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

protocol TweetCellDelegate : class {
    func handleRetweetTapped(cell : TweetCell)
    func handleLikeTapped(cell : TweetCell)
}

class TweetCell : UICollectionViewCell {
    
    var tweet : Tweet? {
        didSet {
            configure()
        }
    }
    
    weak var delegate : TweetCellDelegate?
    
    //MARK: - parts
    private let profileImageView : UIImageView = {
        let iv = UIImageView().profileImageView(setDimencion: 48)
        
        return iv
    }()
    
    private let infoLabel : UILabel = {
        let label = UILabel()
        label.text = "Test Info"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let captionLabel : UILabel = {
        let label = UILabel()
        label.text = "Test"
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    // buttons (user func)
    
    private lazy var commentButton : UIButton = {
        let button = createButton(withImage: #imageLiteral(resourceName: "comment") )
        return button
    }()
    
    private lazy var retweetButton : UIButton = {
        let button = createButton(withImage: #imageLiteral(resourceName: "retweet") )
        button.addTarget(self, action: #selector(handleRetweetTapped(_ :)), for: .touchUpInside)
        return button
    }()
    
    lazy var likeButton : UIButton = {
        let button = createButton(withImage: #imageLiteral(resourceName: "like_unselected") )
        button.addTarget(self, action: #selector(handleLikeTapped(_ :)), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton : UIButton = {
        let button = createButton(withImage: #imageLiteral(resourceName: "share") )
        return button
    }()
    
    
    
    
    
    //MARK: - init Cell
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.anchor(top : topAnchor, left: leftAnchor,paddongTop: 8,paddingLeft: 8)
        
        let captionStack = UIStackView(arrangedSubviews: [infoLabel, captionLabel])
        captionStack.axis = .vertical
        captionStack.distribution = .fillProportionally
        captionStack.spacing = 4
        
        addSubview(captionStack)
        captionStack.anchor(top : profileImageView.topAnchor, left: profileImageView.rightAnchor,right: rightAnchor,paddingLeft: 12,paddingRight: 12)
        
        
        let buttonStack = UIStackView(arrangedSubviews: [commentButton,retweetButton,likeButton,shareButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 72
        addSubview(buttonStack)
        
        buttonStack.centerX(inView: self)
        buttonStack.anchor(bottom : bottomAnchor, paddiongBottom: 8)
        
        let underline = UIView()
        underline.backgroundColor = .lightGray
        addSubview(underline)
        underline.anchor(left : leftAnchor, bottom: bottomAnchor, right: rightAnchor,height: 1)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        guard var tweet = tweet else {return}
        captionLabel.text = tweet.caption
        
        tweet.checkTweetDidlike { (didlike) in
            if didlike {
                tweet.didLike = true
                self.likeButton.tintColor = .red
                self.likeButton.setImage(#imageLiteral(resourceName: "like_filled"), for: .normal)
            } else {
                tweet.didLike = false
                self.likeButton.tintColor = .lightGray
                self.likeButton.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
            }
        }
        
        let vm = TweetViewModel(tweet: tweet)
        
        profileImageView.image = downloadImageFromData(picturedata: vm.profileImageString)
        
        infoLabel.attributedText = vm.userInfoText
//        likeButton.tintColor = vm.likeButtonTintColor
//        likeButton.setImage(vm.likeButtonImage, for: .normal)
        
    }
    
    //MARK: - Delegate Functions
    
    @objc func handleRetweetTapped(_ sender : UIButton) {
        delegate?.handleRetweetTapped(cell: self)
    }
    
    @objc func handleLikeTapped(_ sender : UIButton) {
        delegate?.handleLikeTapped(cell: self)
    }
}

extension TweetCell {
    
    func createButton(withImage image : UIImage) -> UIButton {
        
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .darkGray
        button.setDimension(width: 20, height: 20)
        
        return button
        
    }
}
