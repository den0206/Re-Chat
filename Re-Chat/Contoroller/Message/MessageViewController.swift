//
//  MessageViewController.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/27.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import MessageKit

class MessageViewController :  MessagesViewController {
    
    //MARK: - Vars
    
    var messagesLists : [Message] = []
    
    var chatRoomId : String!
    var memberIds : [String]!
    var membersToPush : [String]!
    
    //MARK: - life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(chatRoomId!)
        configureMessageKit()
    }
    
    
    private func configureMessageKit() {
        messagesCollectionView.backgroundColor = .lightGray
        
        messagesCollectionView.dataSource = self
        
    }
}

//MARK: - Message Datasorce

extension MessageViewController : MessagesDataSource {
    func currentSender() -> SenderType {
        
        return Sender(senderId: User.currentId(), displayName: User.currentUser()!.fullname)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messagesLists[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messagesLists.count
    }
    
    
}
