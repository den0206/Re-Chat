//
//  UploadTweetController.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/15.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class UploadTweetController : UIViewController {
    
    let user : User
    
    //MARK: - Parts
    
    private let profileImage : UIImageView = {
        let iv = UIImageView().profileImageView(setDimencion: 48)
        return iv
    }()
    
    private let captionTextView = InputTextView()
    
    // navigation right button
    
    private lazy var actionButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .lightGray
        button.setTitle("Tweet", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.titleLabel?.textAlignment = .center
        button.isEnabled = false
        
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32 / 2
        button.addTarget(self, action: #selector(handleUploadTweet), for: .touchUpInside)
        
        
        return button
    }()
    
    //MARK: - Life cycle
    
    init(user : User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    
    }
    
    //MARK: - configure UI
    
 
    private func configureUI() {
        configureNavigationbar()
        view.backgroundColor = .white
        
        captionTextView.delegate = self
        
        let imageCaptionStack = UIStackView(arrangedSubviews: [profileImage, captionTextView])
        imageCaptionStack.axis = .horizontal
        imageCaptionStack.spacing = 12
        imageCaptionStack.alignment = .leading
        
        view.addSubview(imageCaptionStack)
        imageCaptionStack.anchor(top : view.safeAreaLayoutGuide.topAnchor, left:  view.leftAnchor,
                                 right: view.rightAnchor,paddongTop: 16,paddingLeft: 16,paddingRight: 16)
        
        profileImage.image = downloadImageFromData(picturedata: user.profileImage)
        
        
        
    }
    
    private func configureNavigationbar() {
         navigationController?.navigationBar.barTintColor = .white
         navigationController?.navigationBar.isTranslucent = false
         
         navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismiss))
         navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
         
     }
     
    
    //MARK: - Actions
    
    @objc func handleUploadTweet() {
        
        guard let caption = captionTextView.text else {return}
        
        guard !caption.isEmpty  else {return}
        
        
        
        showPresentLoadindView(true, message: "Sending...")
        
        // no caption empty

        TweetService.shared.uploadTweet(caption: caption) { (error) in

            if error != nil {
                self.showPresentLoadindView(false)
                self.showAlert(title: "Recheck", message: error!.localizedDescription)
                return
            }
            
            self.dismiss(animated: true) {
                self.showPresentLoadindView(false)
            }

        }

    }
    
    @objc func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}

//MARK: - Textfield Delegate

extension UploadTweetController : UITextViewDelegate {
    
    
    func textViewDidChange(_ textView: UITextView) {
        if !textView.hasText {
            actionButton.backgroundColor = .lightGray
            actionButton.isEnabled = false
        } else {
            actionButton.backgroundColor = .blue
            actionButton.isEnabled = true
        }
        
        
    }
    
}
