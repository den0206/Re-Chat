//
//  InputTextView.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/15.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class InputTextView : UITextView {
    
    //MARK: - Parts
    
    let placeholderLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.text = "What's are you Doing ??"
        return label
    }()
    
    //MARK: - init
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        
        super.init(frame: frame, textContainer: textContainer)
        
        backgroundColor = .white
        font = UIFont.systemFont(ofSize: 16)
        isScrollEnabled = false
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2
        
        
        heightAnchor.constraint(equalToConstant: 200).isActive = true
        addSubview(placeholderLabel)
//        placeholderLabel.anchor(top : topAnchor, left: leftAnchor, paddongTop: 8,paddingLeft: 4)
        placeholderLabel.center(inView: self)
        
     
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // hidden placeholder
    
    @objc func handleTextChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    
    
    
}
