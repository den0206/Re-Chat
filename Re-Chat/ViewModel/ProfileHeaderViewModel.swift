//
//  ProfileHeaderViewModel.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/21.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

enum ProfileFilterOption : Int, CaseIterable {
    
    case tweet
    case reply
    case like
    
    var description : String {
        switch self {
        case .tweet:
            return "Tweet"
        case .reply:
            return "Reply"
        case .like:
            return "Like"
        }
    }
    
    
}


struct ProfileHeaderViewModel {
    
    let user : User
    
    let userNameText : String
    
    var followerString : NSAttributedString? {
        return attributText(withValue: user.stats?.followers ?? 0, text: "followers")
    }
    
    var followingString : NSAttributedString? {
        return attributText(withValue: user.stats?.following ?? 0, text: "following")
    }
    
    var actionButtonTitle : String {
        if user.isCurrentUser {
            return "Edit"
        }
        
        if user.isFollewed {
            return "UnFollow"
        }
        
        if !user.isFollewed {
            return "Follow"
        }
        
        return "Loadinng"
    }
    
    init(user : User) {
        self.user = user
        
        self.userNameText = "@" + user.fullname
    }
    
    var actionButtonColor : UIColor {
        return user.isFollewed ? #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1) : .white
    }
    
    var actionButtonTitleColor : UIColor {
        return user.isFollewed ? .white : .black
    }
    
    fileprivate func attributText(withValue value : Int, text : String) -> NSAttributedString {
        
        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        
        attributedTitle.append(NSMutableAttributedString(string: " \(text)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.lightGray ]))
        
        return attributedTitle
    }
    
}
