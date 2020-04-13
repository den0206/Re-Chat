//
//  RecentCell.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/26.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class RecentCell : UITableViewCell {
    
    // instead of "cell.user .."
    var indexPath : IndexPath!
    
    //MARK: - Parts
    
    private let profileImageView : UIImageView = {
        let iv = UIImageView().profileImageView(setDimencion: 48)
        return iv
    }()
    
    private let withUserNameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "User name"
        return label
    }()
    
    private let lastMessageLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Last message"
        return label
    }()
    
    private let dateLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "3/5"
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .default
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self)
        profileImageView.anchor(left : leftAnchor, paddingLeft: 16)
        
        addSubview(withUserNameLabel)
        withUserNameLabel.anchor(top : topAnchor, left:  profileImageView.rightAnchor,paddongTop: 24, paddingLeft: 24)
        
        addSubview(lastMessageLabel)
        lastMessageLabel.anchor(top : withUserNameLabel.bottomAnchor, left:  profileImageView.rightAnchor,paddongTop: 8,paddingLeft: 24)
        
        addSubview(dateLabel)
        dateLabel.anchor(top : topAnchor, right: rightAnchor,paddongTop: 12,paddingRight: 36)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // user Dictionary without VM
    
    func generateCell(recent : [String : Any], indexPath : IndexPath) {
        self.indexPath = indexPath
        
        withUserNameLabel.text = recent[kWITHUSERFULLNAME] as? String
        self.lastMessageLabel.text = recent[kLASTMESSAGE] as? String
        
        var date : Date!
        
        if let created = recent[kDATE] {
            if (created as! String).count != 14 {
                date = Date()
            } else {
                date = dateFormatter().date(from: created as! String)!
            }
        } else {
            date = Date()
        }
        
        self.dateLabel.text = timeElapsed(date: date)
        
        if let profileImage = recent[kPROFILE_IMAGE] {
            self.profileImageView.image = downloadImageFromData(picturedata: profileImage as! String)
        }
        
        
        
        
    }
}
