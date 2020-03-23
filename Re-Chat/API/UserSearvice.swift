//
//  UserSearvice.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/14.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Firebase

struct UserSearvice {
    
    static let shared = UserSearvice()
    
    func filterUsers(filter : String?, completion : @escaping([User]) -> Void) {
        
        var query : Query!
        
        switch filter {
        case kMAN:
            query = firebaseReference(.User).whereField(kSEX, isEqualTo: 0)
        case kWOMAN :
             query = firebaseReference(.User).whereField(kSEX, isEqualTo: 1)
        default:
            query = firebaseReference(.User)
        }
        
        query.getDocuments { (snapshot, error) in
            var Users = [User]()
            
            guard let snapshot = snapshot else {return}
            
            if !snapshot.isEmpty {
                for document in snapshot.documents {
                    let dictionary = document.data()
                    
                    if document.documentID != Auth.auth().currentUser?.uid {
                          let user = User(uid: document.documentID, dictionary: dictionary)
                        Users.append(user)
                    }
    
                }
                completion(Users)
            }
        }
    }
    
    func userIdToUser(uid : String, completion : @escaping(User) -> Void) {
        
        firebaseReference(.User).document(uid).getDocument { (snapshot, error) in
            guard let snapshot = snapshot else {return}
            if snapshot.exists {
                let dictionary = snapshot.data()!
                let user = User(uid: snapshot.documentID, dictionary: dictionary)
                completion(user)
            }
        }
    }
    
    
    
    func checkUsetIsFollow(uid : String, completion :  @escaping(Bool) -> Void) {
        guard let currentId = Auth.auth().currentUser?.uid else {return}
        
//        followingRefernce(uid: currentId).document(uid).getDocument { (snapshot, error) in
//
//            guard let snapshot = snapshot else {return}
//
//            completion(snapshot.exists)
//        }
        
        followingRefernce(uid: currentId).document(uid).addSnapshotListener { (snapshot, error) in
            
            guard let snapshot = snapshot else {return}
            
            completion(snapshot.exists)
        }
    }
    
    func fetchUserStats(uid : String , completion :  @escaping(UserRelationStats) -> Void) {
        

        firebaseReference(.User).document(uid).addSnapshotListener { (snapshot, error) in
            
            guard let snapshot = snapshot else {return}
            
            if snapshot.exists {
                let dictionary = snapshot.data()!
                
                let followers = dictionary[kFOLLOWERS] as? Int ?? 0
                let following = dictionary[kFOLLOWING] as? Int ?? 0
                
                let stats = UserRelationStats(followers: followers, following: following)
                completion(stats)
                
            }
        }
    }
    
}
