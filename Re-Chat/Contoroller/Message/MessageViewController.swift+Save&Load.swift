//
//  MessageViewController.swift+Save&Load.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/28.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

extension MessageViewController {
    
    //MARK: - Send Out Going
    
    func send_message(text : String?, picture : String?, location : String?, video : NSURL?, audio : String?) {
        
        var outGoingMessage : OutGoingMessage?
        guard let currentUser = User.currentUser() else {return}
        
        if let text = text {
            outGoingMessage = OutGoingMessage(message: text, senderId: currentUser.uid, senderName: currentUser.fullname, status: kDELIVERED, type: kTEXT)
        }
        
        
        // set firestore text & Location Type
        outGoingMessage?.sendMessage(chatRoomid: chatRoomId, messageDictionary: outGoingMessage!.messageDictionary, membersId: memberIds)
        
        
    }
    
}
