//
//  TweetSearvice.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/15.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation
import Firebase

struct TweetService {
    
    static let shared = TweetService()
    
    func uploadTweet(caption : String, completion : @escaping(Error?) -> Void) {
        
        let tweetId = UUID().uuidString
        
        let values = [kUSERID : User.currentId(),
                      kTWEETID : tweetId,
                      kLIKES : 0,
                      kRETWEETS : 0,
                      kCAPTION : caption,
                      kTIMESTAMP : Int(NSDate().timeIntervalSince1970)] as [String : Any]
        
        firebaseReference(.Tweet).document(tweetId).setData(values, completion: completion)
        
    }
    
    
    
}
