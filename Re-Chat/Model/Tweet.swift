//
//  Tweet.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/21.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation

struct Tweet {
    
    let caption : String
    let tweetId : String
    var like : Int
    var retweetCount : Int
    var timestamp : Date!
    let uid : String
    let user : User
    var didLike = false
    
    init(user : User, tweetId : String, dictionary : [String : Any]) {
        self.user = user
        
        self.tweetId = tweetId
        self.uid = dictionary[kUSERID] as? String ?? ""
        self.caption = dictionary[kCAPTION] as? String ?? ""
        self.like = dictionary[kLIKES] as? Int ?? 0
        self.retweetCount = dictionary[kRETWEETS] as? Int ?? 0
        
        if let timestamp = dictionary[kTIMESTAMP] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
    }
    
    
}
