//
//  MessageService.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/26.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Firebase

struct MessageSearvice {
    
    static let shared = MessageSearvice()
    
    //MARK: - Recent
    func fetchRecent(userId : String, comletion :  @escaping([Dictionary<String, Any>]) -> Void) -> ListenerRegistration? {

        return firebaseReference(.Recent).whereField(kUSERID, isEqualTo: userId).order(by: kDATE, descending: true).addSnapshotListener { (snapshot, error) in
            
            guard let snapshot = snapshot else {return}
            
            var recents : [Dictionary<String, Any>] = []
            
            if !snapshot.isEmpty {
                
                for doc in snapshot.documents {
                    
                    let recent = doc.data()
                    
                    if recent[kLASTMESSAGE] as! String != "" && recent[kCHATROOMID] != nil && recent[kRECENTID] != nil {
                        
                        recents.append(recent)
                    }
                }
                
                comletion(recents)
            } else {
                print("No Fetch")
            }
            
            
        }
    }
    
    //MARK: - Message
    
    func firstLoadMessage(chatRoomId : String, completion :  @escaping([NSDictionary], _ lastDocument : DocumentSnapshot?) -> Void) {
        
        firebaseReference(.Message).document(User.currentId()).collection(chatRoomId).order(by: kDATE, descending: false).limit(to: 11).getDocuments { (snapshot, error) in
            
            guard let snapshot = snapshot else {return}
            var sorted : [NSDictionary] = []
            
            if !snapshot.isEmpty {
                
                for doc in snapshot.documents {
                    let dictionary = doc.data() as NSDictionary
                    sorted.append(dictionary)
                }
               
                let lastDocument = snapshot.documents.last
                
                completion(sorted, lastDocument)
                
                
            }
            
        }
    }
    
    func fetchMessages(chatRoomId : String, completion :  @escaping([NSDictionary], _ lastDocument : DocumentSnapshot?) -> Void) -> ListenerRegistration? {
        
      return firebaseReference(.Message).document(User.currentId()).collection(chatRoomId).order(by: kDATE, descending: false).limit(to: 11).addSnapshotListener { (snapshot, error) in
            
            
            guard let snapshot = snapshot else {return}
            var sorted : [NSDictionary] = []
            
            if !snapshot.isEmpty {
                
                for doc in snapshot.documents {
                    let dictionary = doc.data() as NSDictionary
                    sorted.append(dictionary)
                }
                
                let lastDocument = snapshot.documents.last
                
                completion(sorted, lastDocument)
                
                
            }
            
        }
        
    }
    
    
}
