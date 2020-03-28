//
//  OutGoingMessage.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/28.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation
import UIKit


struct OutGoingMessage {
    
    // avoid
   let messageDictionary : NSMutableDictionary
   
   
   // Text
   
   init(message : String, senderId : String, senderName : String, status : String, type : String) {
       
       messageDictionary = NSMutableDictionary(objects: [message, senderId,senderName,status,type], forKeys: [kMESSAGE as NSCopying, kSENDERID as NSCopying, kSENDERNAME as NSCopying, kSTATUS as NSCopying, kTYPE as NSCopying])
   }
    
    
    func sendMessage(chatRoomid : String, messageDictionary : NSMutableDictionary, membersId : [String]) {
        
        let messageId = UUID().uuidString
        let date = dateFormatter().string(from: Date())
        
        messageDictionary[kMESSAGEID] = messageId
        messageDictionary[kDATE] = date
    
        
        for member in membersId {
            firebaseReference(.Message).document(member).collection(chatRoomid).document(messageId).setData(messageDictionary as! [String : Any])
        }
        
        // update LastMessage & Counter (Recent Func)
        updateRecent(chatRoomId: chatRoomid, lastMessage: messageDictionary[kMESSAGE] as! String)
        
        
    }
}
