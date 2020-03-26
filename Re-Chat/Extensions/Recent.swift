//
//  Recent.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/25.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

func startPrivateChat(user1 : User, user2 : User) -> String {
    
    let user1Id = user1.uid
    let user2Id = user2.uid
    
    var chatRoomId = ""
    
    let value = user1Id.compare(user2Id).rawValue
    
    if value < 0 {
        chatRoomId = user1Id + user2Id
    } else {
        chatRoomId = user2Id + user1Id
    }
    
    let members = [user1Id,user2Id]
    
    // create recent
    createRecentChat(members: members, chatRoomId: chatRoomId, withUserName: "", type: kPRIVATE, users: [user1,user2])
    
    return chatRoomId
}

func createRecentChat(members : [String], chatRoomId : String, withUserName : String, type : String, users : [User]?) {
    
    var tempMembers = members
    
    firebaseReference(.Recent).whereField(kCHATROOMID, isEqualTo: chatRoomId).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {return}
        
        // check exist
        if !snapshot.isEmpty {
            for recent in snapshot.documents {
                let currentRecent = recent.data()
                
                if let currentUserId = currentRecent[kUSERID] {
                    if members.contains(currentUserId as! String) {
                        tempMembers.remove(at: tempMembers.firstIndex(of: currentUserId as! String)!)
                    }
                }
            }
        }
        
        for userId in tempMembers {
            
            // set FireStore
            createRecentToFirestore(userId: userId, chatRoomId: chatRoomId, members: members, withUserName: withUserName, type: type, users: users)
            
        }
        
    }
    
}

func createRecentToFirestore(userId : String,chatRoomId : String,members : [String],withUserName : String, type : String, users : [User]?) {
    
    let localReference = firebaseReference(.Recent).document()
    let recentId = localReference.documentID
    
    let date = dateFormatter().string(from: Date())
    
    var recent : [String : Any]!
    
    if type == kPRIVATE {
        // for private
        
        var withUser : User?
        
        if users != nil && users!.count > 0 {
            
            if userId == User.currentId() {
                withUser = users!.last!
            } else {
                withUser = users?.first
            }
        }
        
        recent = [kRECENTID : recentId,
                  kUSERID : userId,
                  kCHATROOMID : chatRoomId,
                  kMEMBERS : members,
                  kMEMBERSTOPUSH : members,
                  kWITHUSERFULLNAME : withUser!.fullname,
                  kWITHUSERUSERID : withUser!.uid,
                  kLASTMESSAGE : "",
                  kCOUNTER : 0,
                  kDATE : date,
                  kTYPE : type ] as [String : Any]
    } else {
        // for grouu
    }
    
    localReference.setData(recent)
}
