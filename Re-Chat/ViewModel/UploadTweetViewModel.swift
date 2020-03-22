//
//  UploadTweetViewModel.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/22.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

enum UploadTweetConfiguration {
    case tweet
    case reply(Tweet)
}

struct UploadTweetViewModel {
    let actionButtonTitle : String
    let placeholderText : String
    var shouldShowReplyLabel : Bool
    var replyText : String?
    
    init(config : UploadTweetConfiguration) {
        
        switch config {
        case .tweet :
            actionButtonTitle = "Tweet"
            placeholderText = "Are you doing??"
            shouldShowReplyLabel = false
        case .reply(let tweet) :
            actionButtonTitle = "Reply"
            placeholderText = "Tweet For reply"
            shouldShowReplyLabel = true
            replyText = "Replying to \(tweet.user.fullname)"
            
        }
    }
}

