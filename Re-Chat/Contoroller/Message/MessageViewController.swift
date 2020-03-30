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
    var objectMessages : [NSDictionary] = []
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
    
    /// Avatars
    var withUsers : [User] = []
    var avatarItems : NSMutableDictionary? {
        didSet {
            messagesCollectionView.reloadData()
        }
    }
    var avatarImageDictionary : NSMutableDictionary?
    
    //MARK: - life Cycle
    
    deinit {
        newChatListner?.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        configureMessageKit()
        configureAccesaryView()
        
        self.avatarItems = [:]
        getCustomTitle()
        
        loadFirstMessage()
        

        
        
    }
    
    //MARK: - configure UI
    
    
    private func configureMessageKit() {
        
        showPresentLoadindView(true)
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        messageInputBar.delegate = self
        
        maintainPositionOnKeyboardFrameChanged = true
        
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
    
    private func getCustomTitle() {
        
        guard let memberIds = memberIds else {return}
        
        UserSearvice.shared.fetchWithUsers(userIds: memberIds) { (usersArray) in
    
            self.withUsers = usersArray
            
            // always Show avatar
            for user in self.withUsers {
                self.avatarImageFrom(user: user)
            }
            
            
            
        }
        
    }
    
    private func avatarImageFrom(user : User) {
        
        if user.profileImage != "" {
            dataImageFromString(picString: user.profileImage) { (imageData) in
                
                if imageData == nil {
                    return
                }
                
                if self.avatarImageDictionary != nil {
                    self.avatarImageDictionary!.removeObject(forKey: user.uid)
                    self.avatarImageDictionary!.setObject(imageData!, forKey: user.uid as NSCopying)
                } else {
                    self.avatarImageDictionary = [user.uid : imageData!]
                }
                
                self.createAvatarItem(avatarDictionary: avatarImageDictionary)
            }
            
        }
        
    }
    
    private func createAvatarItem(avatarDictionary : NSMutableDictionary?) {
        let defaultAvatar = Avatar(image: UIImage(named: "avatarPlaceholder"), initials: "?")
        
        if avatarDictionary != nil {
            
            for userId in memberIds {
                if let avataImageData = avatarDictionary![userId] {
                    let avatarItem = Avatar(image: UIImage(data: avataImageData as! Data), initials: "?")
                    
                    self.avatarItems!.setValue(avatarItem, forKey: userId)
                } else {
                    self.avatarItems!.setValue(defaultAvatar, forKey: userId)
                }
            }
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
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        let messageDictionary = objectMessages[indexPath.section]
        let status : NSAttributedString
        let atributeStringColor = [NSAttributedString.Key.foregroundColor : UIColor.lightGray]
        
        if isFromCurrentSender(message: message) {
            switch messageDictionary[kSTATUS] as! String{
            case kDELIVERED:
                status = NSAttributedString(string: kDELIVERED, attributes:  [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2), NSAttributedString.Key.foregroundColor : UIColor.lightGray] )
            case kREAD :
                status = NSAttributedString(string: kREAD, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1), NSAttributedString.Key.foregroundColor : UIColor.lightGray])
            default:
                status = NSAttributedString(string: "✔︎", attributes:  [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
            }
            
            return status
        }
        
        return nil
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
       
           let message = messagesLists[indexPath.section]
           var avatar : Avatar
           
           if avatarItems != nil {
               
               if let avatarData = avatarItems!.object(forKey: message.sender.senderId) {
                   
                   avatar = avatarData as! Avatar
                   avatarView.set(avatar: avatar)
               }
                
           } else {
               avatar = Avatar(image: UIImage(named: "avatarPlaceholder") , initials: "?")
               avatarView.set(avatar: avatar)
           }
       }

    
}

//MARK: Message Layout Delagate

extension MessageViewController : MessagesLayoutDelegate {
    
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 30
    }
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 10
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
    
    func didSelect(option: AccesarySheetOptions) {
        
        let camera = Camera(delegate_: self)
        
        switch option {
      
        case .camera:
            camera.PresentPhotoCamera(target: self, canEdit: false)
        case .photo:
            camera.PresentPhotoLibrary(target: self, canEdit: true)
        case .video:
            camera.PresentVideoLibrary(target: self, canEdit: false)
        case .location:
            print("Location")
        }
    }
    
    
    func handleDismiss(view: AccesarySheetLauncher) {
        UIView.animate(withDuration: 0.5) {
            view.blackView.alpha = 0
            self.messageInputBar.isHidden = false
            view.tableview.frame.origin.y += 300
        }
    }
    
    //MARK: - Image picker delgate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // dismiss actionSheet
        handleDismiss(view: self.acsesarrySheet)
        
        self.dismiss(animated: true) {
            let pic = info[.editedImage] as? UIImage
            let video = info[.mediaURL] as? NSURL
            
            self.send_message(text: nil, picture: pic, location: nil, video: video, audio: nil)

        }
    }
    
    
    
    @objc func showAudio(_ sender : InputBarButtonItem) {
        print("Audio")
    }
}
