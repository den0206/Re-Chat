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
        
        showPresentLoadindView(true)
        
        newChatListner = firebaseReference(.Message).document(User.currentId()).collection(chatRoomId).order(by: kDATE, descending: true).limit(to: 11).addSnapshotListener { (snapshot, error) in
            
            guard let snapshot = snapshot else {return}
            
            if !snapshot.isEmpty {
                let sorted = ((dictionaryFromSnapshots(snapshots: snapshot.documentChanges)) as NSArray).sortedArray(using: [NSSortDescriptor(key: kDATE, ascending: true)]) as! [NSDictionary]
                
                for message in sorted {
                    _ = self.appendMessage(messageDeictionary: message)
                   
                }
                
                // only first load
                if !self.firstLoaded {
                    self.lastDocument = snapshot.documents.last
                    self.firstLoaded = true
                }
               
                
                DispatchQueue.main.async {
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToBottom(animated: true)
                    self.showPresentLoadindView(false)
                }
                
                 print(self.lastDocument?.data())
               
                

                
            } else {
                self.showPresentLoadindView(false)
            }
            
        }
        
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
            
            print("Celled")
            // upodate read Status
            OutGoingMessage.updateMessage(messageId: messageDeictionary[kMESSAGEID] as! String, chatRoomId: chatRoomId, membersIds: memberIds)
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
