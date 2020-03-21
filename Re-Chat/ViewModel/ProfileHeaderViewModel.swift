//
//  ProfileHeaderViewModel.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/21.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

struct ProfileHeaderViewModel {
    
    let user : User
    
    let userNameText : String
    
    init(user : User) {
        self.user = user
        
        self.userNameText = "@" + user.fullname
    }
    
}
