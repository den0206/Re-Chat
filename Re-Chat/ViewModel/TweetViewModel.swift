//
//  TweetViewModel.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/22.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

struct TweetViewModel {
    let tweet : Tweet
    let user : User
    
    var profileImageString : String {
        return tweet.user.profileImage
    }
    
    var fullnameText : String {
        return "\(user.fullname)"
    }
    
    var usernameText : String {
        return "@\(user.fullname)"
    }
    
    var headerTimeStamp : String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a · MM/dd/yyyy"
        return formatter.string(from: tweet.timestamp)
    }
    
    var retweetAttributedString : NSAttributedString? {
        return attributedText(withValue: tweet.retweetCount, text: "Retweets")
    }
    
    var likesAttributedString : NSAttributedString? {
        return attributedText(withValue: tweet.likes, text: "Likes")
    }
    
    var likeButtonTintColor : UIColor {
        return tweet.didLike ? .red : .lightGray
        
    }
    
    var likeButtonImage : UIImage {
        let image = tweet.didLike ? "like_filled" : "like"
        return UIImage(named: image)!
    }
    
    
    var timestamp : String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        
        let now = Date()
        return formatter.string(from: tweet.timestamp, to: now) ?? "2m"
    }
    
    var userInfoText : NSAttributedString {
      let title = NSMutableAttributedString(string: user.fullname, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        
        
        title.append(NSAttributedString(string: "@\(user.fullname)", attributes: [.font: UIFont.boldSystemFont(ofSize: 14),  .foregroundColor: UIColor.lightGray]))
        
        title.append(NSAttributedString(string: " · \(timestamp)", attributes: [.font: UIFont.boldSystemFont(ofSize: 14),  .foregroundColor: UIColor.lightGray]))
        
        return title
    }
    
    init(tweet : Tweet) {
        self.tweet = tweet
        self.user = tweet.user
    }
    
    fileprivate func attributedText(withValue value : Int , text :String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)])
        
        attributedTitle.append(NSAttributedString(string: " \(text)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.lightGray]))
        
        return attributedTitle
        
    }
    
    func size (forWidth width : CGFloat) -> CGSize {
        let measurement = UILabel()
        measurement.text = tweet.caption
        measurement.numberOfLines = 0
        measurement.lineBreakMode = .byWordWrapping
        measurement.translatesAutoresizingMaskIntoConstraints = false
        measurement.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        return measurement.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
}
