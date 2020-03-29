//
//  IncomingMessage.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/28.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation
import MessageKit


struct IncomingMessage {
    
    //MARK: - Pats
    var collectionView : MessagesCollectionView
    
    init(_collectionView : MessagesCollectionView) {
        collectionView = _collectionView
    }
    
    //MARK: - Return Message Type
    
    func createMessage(messageDictionary : NSDictionary, chatRoomId : String) -> Message? {
        
        var message : Message?
        
        let type = messageDictionary[kTYPE] as! String
        
        switch type {
      
        case kTEXT :
            message = textMessage(messageDictionary: messageDictionary, chatRoomId: chatRoomId)
        case kPICTURE :
            message = pictureMessage(messageDictionary: messageDictionary, chatRoomId: chatRoomId)
        case kVIDEO :
            message = videoMessage(messageDictionary: messageDictionary, chatRoomId: chatRoomId)
        default :
            print("Typeがわからない")
        }
        
        
        if message != nil {
            return message
        }
        
        return nil
        
    }
    
    //MARK: - create each message Type
    
    // text
    
    func textMessage(messageDictionary : NSDictionary, chatRoomId : String) -> Message {
        
        let name = messageDictionary[kSENDERNAME] as! String
        let userid = messageDictionary[kSENDERID] as! String
        let messageId = messageDictionary[kMESSAGEID] as! String
        
        var date : Date!
        
        if let created = messageDictionary[kDATE] {
            if (created as! String).count !=  14 {
                date = Date()
            } else {
                date = dateFormatter().date(from: created as! String)
            }
        } else {
            date = Date()
        }
        
        let text = messageDictionary[kMESSAGE] as! String
        
        return Message(text: text, sender: Sender(senderId: userid, displayName: name), messageId: messageId, date: date)
        
    }
    
    // picture
    
    func pictureMessage(messageDictionary : NSDictionary, chatRoomId : String) -> Message? {
        
        let name = messageDictionary[kSENDERNAME] as! String
        let userid = messageDictionary[kSENDERID] as! String
        let messageId = messageDictionary[kMESSAGEID] as! String
        
        var date : Date!
        
        if let created = messageDictionary[kDATE] {
            if (created as! String).count !=  14 {
                date = Date()
            } else {
                date = dateFormatter().date(from: created as! String)
            }
        } else {
            date = Date()
            
        }
        
        let image = downLoadImageFromString(imageLink: messageDictionary[kPICTURE] as! String)
        
        if image != nil {
            return Message(image: image!, sender: Sender(senderId: userid, displayName: name), messageId: messageId, date: date)
        }
        
        return nil
        
    }
    
    /// video
    
    func videoMessage(messageDictionary : NSDictionary, chatRoomId : String) -> Message? {
        
        let name = messageDictionary[kSENDERNAME] as! String
        let userid = messageDictionary[kSENDERID] as! String
        let messageId = messageDictionary[kMESSAGEID] as! String
        
        var date : Date!
        
        if let created = messageDictionary[kDATE] {
            if (created as! String).count !=  14 {
                date = Date()
            } else {
                date = dateFormatter().date(from: created as! String)
            }
        } else {
            date = Date()
            
        }
        
        let videoUrl = NSURL(fileURLWithPath: messageDictionary[kVIDEO] as! String)
        let thumbnail = downloadImageFromData(picturedata: messageDictionary[kTHUMBNAIL] as! String)
        
        var videoItem = MockVideoItem(withFileUrl: videoUrl, thumbnail: thumbnail!)
        
        downloadVideo(videoLink: messageDictionary[kVIDEO] as! String) { (_ , fileName) in
            
            let url = NSURL(fileURLWithPath: fileInDocumentDictionary(filename: fileName))
            videoItem = MockVideoItem(withFileUrl: url, thumbnail: thumbnail!)
        }
        
        
        
        if videoItem.fileUrl != nil && videoItem.image != nil {
            return Message(media: videoItem, sender: Sender(senderId: userid, displayName: name), messageId: messageId, date: date)
        } else {
            return nil
            
            
        }
    }
    
    func returnVideoMessage(name: String, userId : String, messageId : String, date : Date, videoItem : MockVideoItem) -> Message? {
        if videoItem.fileUrl != nil && videoItem.image != nil {
            return Message(media: videoItem, sender: Sender(senderId: userId, displayName: name), messageId: messageId, date: date)
        } else {
            return nil
        }
    }
    
    
}
