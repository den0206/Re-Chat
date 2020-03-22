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
    
    func fetchAllTweets(completion : @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        firebaseReference(.Tweet).getDocuments { (snapshot, error) in
            
            guard let snapshot = snapshot else {return}
            
            if !snapshot.isEmpty {
                for documents in snapshot.documents {
                    guard let uid = documents.data()[kUSERID] as? String else {return}
                    print(uid)
                    
                    UserSearvice.shared.userIdToUser(uid: uid) { (user) in
                        // convertTweet Model
                        let tweet = Tweet(user: user, tweetId: uid, dictionary: documents.data())
                        tweets.append(tweet)
                        completion(tweets)
                    }
                    
                }
                
            }
        }
        
    }
    
    //MARK: - Profile
    
    func fetchTweetSpecificUser(user : User, completion : @escaping([Tweet]) -> Void) {
        
        var tweets = [Tweet]()
        
        firebaseReference(.Tweet).whereField(kUSERID, isEqualTo: user.uid).getDocuments { (snapshot, error) in
            
            guard let snapshot = snapshot else {return}
            
            if !snapshot.isEmpty {
                for document in snapshot.documents {
                    let dictionary = document.data()
                    let tweet = Tweet(user: user, tweetId: document.documentID, dictionary: dictionary)
                    
                    tweets.append(tweet)
                }
                completion(tweets)
            }
        }
        
    }
    
    
    
}
