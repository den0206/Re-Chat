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
    
    func uploadTweet(caption : String, type :UploadTweetConfiguration, completion : @escaping(Error?) -> Void) {
        
        let tweetId = UUID().uuidString
        
        var values = [kUSERID : User.currentId(),
                      kTWEETID : tweetId,
                      kLIKES : 0,
                      kRETWEETS : 0,
                      kCAPTION : caption,
                      kTIMESTAMP : Int(NSDate().timeIntervalSince1970)] as [String : Any]
        
        switch type {
       
        case .tweet:
             firebaseReference(.Tweet).document(tweetId).setData(values, completion: completion)
        case .reply(let tweet):
            
            values[kREPLYINGTO] = tweet.user.fullname
            values[kUSERIDTO] = tweet.user.uid

            tweetReplyReference(tweetId: tweet.tweetId).document(tweetId).setData(values, completion: completion)

            // increment count

        firebaseReference(.Tweet).document(tweet.tweetId).updateData([kRETWEETS : FieldValue.increment((Int64(1)))])

            
            
        }
        
       
        
    }
    
    func fetchAllTweets(completion : @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        firebaseReference(.Tweet).getDocuments { (snapshot, error) in
            
            guard let snapshot = snapshot else {return}
            
            if !snapshot.isEmpty {
                for document in snapshot.documents {
                    guard let uid = document.data()[kUSERID] as? String else {return}
                    
                    UserSearvice.shared.userIdToUser(uid: uid) { (user) in
                        // convertTweet Model
                        let tweet = Tweet(user: user, tweetId: document.documentID, dictionary: document.data())
                        tweets.append(tweet)
                        completion(tweets)
                    }
                    
                }
                
            }
        }
        
    }
    
    
    func checkIfUserLikedTweet(_ tweet : Tweet, completion : @escaping(Bool) -> Void) {
       guard let currentUid = Auth.auth().currentUser?.uid else {return}
        firebaseReference(.Tweet).document(tweet.tweetId).collection(kLIKES).document(currentUid).getDocument { (snapshot, error) in
            
            guard let snapshot = snapshot else {return}
            
            completion(snapshot.exists)
        }

    }
    
    
    func fetchSingleTweet(tweetId : String, completion : @escaping(Tweet) -> Void) {
        
        firebaseReference(.Tweet).document(tweetId).getDocument { (snapshot, error) in
            
            guard let snapshot = snapshot else {return}
            
            if snapshot.exists {
                let dictionary = snapshot.data()!
                let uid = dictionary[kUSERID] as! String
                
                UserSearvice.shared.userIdToUser(uid: uid) { (user) in
                    let tweet = Tweet(user: user, tweetId: tweetId, dictionary: dictionary)
                    completion(tweet)
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
    
    func fetchReply(user : User, completion : @escaping([Tweet]) -> Void) {
        
        Firestore.firestore().collectionGroup(kRETWEETS).whereField(kUSERIDTO, isEqualTo: user.uid).getDocuments { (snapshot, error) in
            
            var replyTweets = [Tweet]()
            
            guard let snapshot = snapshot else {
                
                // set index
                print(error?.localizedDescription)
                return}
            
            if !snapshot.isEmpty {
                for document in snapshot.documents {
                    let dictionary = document.data()
                    let tweetId = dictionary[kTWEETID] as! String
                    let userId = dictionary[kUSERID] as! String
                    
                    UserSearvice.shared.userIdToUser(uid: userId) { (user) in
                        let tweet = Tweet(user: user, tweetId: tweetId, dictionary: dictionary)
                        replyTweets.append(tweet)
                        completion(replyTweets)
                    }
                }
            }
        }
    }
    
    func fetchLikes(user : User, completion : @escaping([Tweet]) -> Void) {
        
        var likesTweets = [Tweet]()
        
        Firestore.firestore().collectionGroup(kLIKES).whereField(kUSERID, isEqualTo: user.uid).getDocuments { (snapshot, error) in
            
            guard let snapshot = snapshot else {
                print(error!.localizedDescription)
                return}
            
            if !snapshot.isEmpty {
                for document in snapshot.documents {
                    
                    let dictionary = document.data()
                  
                    let tweetId = dictionary[kTWEETID] as! String
                    
                    TweetService.shared.fetchSingleTweet(tweetId: tweetId) { (likedTweet) in
                        var tweet = likedTweet
                        tweet.didLike = true
                        
                        likesTweets.append(tweet)
                        completion(likesTweets)
                        
                    }
                }
            }
            
            
        }
    }
    
    
    
}
