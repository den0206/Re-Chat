//
//  MessageViewController.swift+Save&Load.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/28.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit


extension MessageViewController {
    
    //MARK: - Save Area
    
    //Send Out Going
    
    func send_message(text : String?, picture : String?, location : String?, video : NSURL?, audio : String?) {
        
        var outGoingMessage : OutGoingMessage?
        guard let currentUser = User.currentUser() else {return}
        
        if let text = text {
            outGoingMessage = OutGoingMessage(message: text, senderId: currentUser.uid, senderName: currentUser.fullname, status: kDELIVERED, type: kTEXT)
        }
        
        
        // set firestore text & Location Type
        outGoingMessage?.sendMessage(chatRoomid: chatRoomId, messageDictionary: outGoingMessage!.messageDictionary, membersId: memberIds)
        
        
    }
    
    //MARK: - Load Area
    
    func loadFirstMessage() {
        
        MessageSearvice.shared.firstLoadMessage(chatRoomId: chatRoomId) { (allMessages, lastDocument) in
            
            // filter
            self.loadMessages = self.checkCorrectType(allMessages: allMessages)
            
            for message in self.loadMessages {
                _ = self.appendMessage(messageDeictionary: message)
            }
            
            // listen New Chat
            self.listenNewChat()
        }
    
    }
    
    func listenNewChat() {
        
        var lastMessageDate = "0"
        
        if loadMessages.count > 0 {
            lastMessageDate = loadMessages.last![kDATE] as! String
        }
        
        newChatListner = firebaseReference(.Message).document(User.currentId()).collection(chatRoomId).whereField(kDATE, isGreaterThan: lastMessageDate).addSnapshotListener({ (snapshot, error) in
            
            guard let snapshot = snapshot else {return}
            
            if !snapshot.isEmpty {
                print("Listen!")
                for diff in snapshot.documentChanges {
                    if (diff.type == .added) {
                        let dic = diff.document.data() as NSDictionary
                        
                        if let type = dic[kTYPE] {
                            if self.legitType.contains(type as! String) {
                                _ = self.appendMessage(messageDeictionary: dic)
                            }
                        }
                    }
                }
            }
        })
        
    }

    
}

//MARK: - Helpers

extension MessageViewController {
    private func checkCorrectType(allMessages: [NSDictionary]) -> [NSDictionary] {
        var tempMessages = allMessages
        
        for message in tempMessages {
            if message[kTYPE]  != nil {
                if !self.legitType.contains(message[kTYPE] as! String) {
                    tempMessages.remove(at: tempMessages.firstIndex(of: message)!)
                }
            } else {
                tempMessages.remove(at: tempMessages.firstIndex(of: message)!)
            }
        }
        
        return tempMessages
    }
    
    private func appendMessage(messageDeictionary : NSDictionary) -> Bool {
        
        let incomingMessage = IncomingMessage(_collectionView: self.messagesCollectionView)
        
        if isInComing(messageDictionary: messageDeictionary) {
            // upodate read Status
            
        }
        
        let message = incomingMessage.createMessage(messageDictionary: messageDeictionary, chatRoomId: chatRoomId)
        
        if message != nil {
            messagesLists.append(message!)
        }
        
        return isInComing(messageDictionary: messageDeictionary)
        
        
        
    }
    
    private func isInComing(messageDictionary : NSDictionary) -> Bool {
        
        var inComing = (User.currentId() == messageDictionary[kSENDERID] as! String) ? false : true
        
        return inComing
    }
    
}
