//
//  OutGoingMessage.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/28.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation
import UIKit


class OutGoingMessage {
    
    // avoid
   let messageDictionary : NSMutableDictionary
   
   
   // Text
   
   init(message : String, senderId : String, senderName : String, status : String, type : String) {
       
       messageDictionary = NSMutableDictionary(objects: [message, senderId,senderName,status,type], forKeys: [kMESSAGE as NSCopying, kSENDERID as NSCopying, kSENDERNAME as NSCopying, kSTATUS as NSCopying, kTYPE as NSCopying])
    }
    
    // pic
    
    init(message : String, pictureLink : String, senderId : String, senderName : String, status : String, type : String) {
        
        messageDictionary = NSMutableDictionary(objects: [message,pictureLink,senderId,senderName,status,type], forKeys: [kMESSAGE as NSCopying,kPICTURE as NSCopying,kSENDERID as NSCopying, kSENDERNAME as NSCopying, kSTATUS as NSCopying, kTYPE as NSCopying])
        
    }
    
    // video
    
    init(message : String, videoLink : String, thumbnail : NSData, senderId : String, senderName : String, status : String, type : String) {
        
        // encode Thumbnail
        let picThumb = thumbnail.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        messageDictionary = NSMutableDictionary(objects: [message,videoLink,picThumb, senderId,senderName,status,type], forKeys: [kMESSAGE as NSCopying,kVIDEO as NSCopying,kTHUMBNAIL as NSCopying,kSENDERID as NSCopying, kSENDERNAME as NSCopying, kSTATUS as NSCopying, kTYPE as NSCopying])
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
    
    // update Read Message
    
    class func updateMessage(messageId : String, chatRoomId : String, membersIds : [String]) {
        
        let readDate = dateFormatter().string(from: Date())
        let value = [kSTATUS : kREAD,
                     kREADDATE : readDate]
        
        for userId in membersIds {
            firebaseReference(.Message).document(userId).collection(chatRoomId).document(messageId).getDocument { (snapshot, error) in
                
                guard let snapshot = snapshot else {return}
                
                if snapshot.exists {
                    firebaseReference(.Message).document(userId).collection(chatRoomId).document(messageId).updateData(value)
                }
            }
        }
    }
}
