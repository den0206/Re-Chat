//
//  MessageViewController.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/27.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import FirebaseFirestore
import MessageKit
import InputBarAccessoryView

struct Sender : SenderType {
    
    var senderId: String
    var displayName: String

}

class MessageViewController :  MessagesViewController {
    
    //MARK: - Vars
    
    var loadMessages : [NSDictionary] = []
    var messagesLists : [Message] = [] {
        didSet {
            messagesCollectionView.reloadData()
        }
    }
    // instant vars
    var chatRoomId : String!
    var memberIds : [String]!
    var membersToPush : [String]!
    
    let refreshController = UIRefreshControl()
    var firstLoaded = false
    
    let legitType = [kAUDIO, kVIDEO, kLOCATION, kTEXT, kPICTURE]
    private var acsesarrySheet : AccesarySheetLauncher!
    
    // fireStore listener
    var newChatListner : ListenerRegistration?
    var lastDocument : DocumentSnapshot?  {
        didSet {
            configureRefreshController()
        }
    }
    
    //MARK: - life Cycle
    
    deinit {
        newChatListner?.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMessageKit()
        configureAccesaryView()
        
        loadFirstMessage()
        
        
    }
    
    //MARK: - configure UI
    
    
    private func configureMessageKit() {
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        messageInputBar.delegate = self
        
        hideCurrentUserAvatar()
        configureInputView()
        
        
    }
    
    private func configureInputView() {
        messageInputBar.sendButton.tintColor = .darkGray
        messageInputBar.backgroundView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        messageInputBar.inputTextView.backgroundColor = .white
    }
    
    private func configureRefreshController () {
        if messagesLists.count >= 11 {
            messagesCollectionView.addSubview(refreshController)
            refreshController.addTarget(self, action: #selector(refresh(_ :)), for: .valueChanged)
        }
        
    }
    
    @objc func refresh(_ sender : UIRefreshControl) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            self.fetchMoreMessage()
            
            
            self.refreshController.endRefreshing()
            
            
        }
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
    
    func hideCurrentUserAvatar() {
        let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
        layout?.sectionInset = UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 8)
        
        // Hide the outgoing avatar and adjust the label alignment to line up with the messages
        layout?.setMessageOutgoingAvatarSize(.zero)
        layout?.setMessageOutgoingMessageTopLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)))
        layout?.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)))
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        if indexPath.section % 3 == 0 {
            
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
    
    // TODO: - Add Read Status

    
}

//MARK: Message Layout Delagate

extension MessageViewController : MessagesLayoutDelegate {
    
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 30
    }
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 35
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 30
    }
}

//MARK: Message Dissplay Delegate

extension MessageViewController : MessagesDisplayDelegate {
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .black
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        isFromCurrentSender(message: message) ?
        UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1) :
        UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
               
               return .bubbleTail(corner, .curved)
    }
    
    func audioTintColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
         return isFromCurrentSender(message: message) ? .white : UIColor(red: 15/255, green: 135/255, blue: 255/255, alpha: 1.0)
    }
    

}

//MARK: - inpurbar delegate

extension MessageViewController : InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        for component in inputBar.inputTextView.components {
            if let text = component as? String {
                self.send_message(text: text, picture: nil, location: nil, video: nil, audio: nil)
            }
        }
        
        finishSendMessage()
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        
        if text == "" {
            showAudioButton()
        } else {
            
            messageInputBar.setStackViewItems([messageInputBar.sendButton], forStack: .right, animated: true)
        }
    }
    
    // finish Sending
    func finishSendMessage() {
        messageInputBar.inputTextView.text = String()
        messageInputBar.invalidatePlugins()
        
        messageInputBar.sendButton.startAnimating()
        messageInputBar.inputTextView.placeholder = "Sending..."
        DispatchQueue.global(qos: .default).async {
            // fake send request task
            sleep(1)
            DispatchQueue.main.async { [weak self] in
                self?.messageInputBar.sendButton.stopAnimating()
                self?.messageInputBar.inputTextView.placeholder = "Aa"
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
        
    }
}

//MARK: - configure Accesary view

extension MessageViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate, AccesarySheetLauncherDelegate {
   
    
    private func configureAccesaryView() {
        
        // left button
        let optionItem = InputBarButtonItem(type: .system)
        optionItem.tintColor = .darkGray
        optionItem.image = UIImage(named: "clip")
        
        optionItem.setSize(CGSize(width: 60, height: 30), animated: true)
        optionItem.addTarget(self, action: #selector(showOption(_ :)), for: .touchUpInside)
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: true)
        messageInputBar.setStackViewItems([optionItem], forStack: .left, animated: true)
        
        // right
        showAudioButton()
        
        
    }
    
    private func showAudioButton() {
        let micItem = InputBarButtonItem(type: .system)
        micItem.tintColor = .darkGray
        micItem.image = UIImage(named: "mic")
        
        micItem.setSize(CGSize(width: 60, height: 30), animated: true)
        micItem.addTarget(self, action: #selector(showOption(_ :)), for: .touchUpInside)
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setRightStackViewWidthConstant(to: 50, animated: true)
        messageInputBar.setStackViewItems([micItem], forStack: .right, animated: true)
    }
    
    
    @objc func showOption(_ sender : InputBarButtonItem) {
        messageInputBar.inputTextView.resignFirstResponder()
        messageInputBar.isHidden = true
        
        acsesarrySheet = AccesarySheetLauncher()
        acsesarrySheet.show()
        acsesarrySheet.delegate = self
    }
    
    // AccesarySheet Delegate
    
    func handleDismiss(view: AccesarySheetLauncher) {
        UIView.animate(withDuration: 0.5) {
            view.blackView.alpha = 0
            self.messageInputBar.isHidden = false
            view.tableview.frame.origin.y += 300
        }
    }
    
    
    
    @objc func showAudio(_ sender : InputBarButtonItem) {
        print("Audio")
    }
}
