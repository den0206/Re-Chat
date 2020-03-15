//
//  User.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/14.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation
import Firebase

enum sexType : Int {
    case man
    case woman
}


class User {
    
    let email : String
    var fullname : String
    let uid : String
    let profileImage : String
    var sex : sexType!
    
    
    init(uid : String, dictionary : [String : Any]) {
        
        self.uid = uid
        
        self.fullname = dictionary[kFULLNAME] as? String ?? ""
        self.email = dictionary[kEMAIL] as? String ?? ""
        self.profileImage = dictionary[kPROFILE_IMAGE] as? String ?? ""
        
        if let index = dictionary[kSEX] as? Int {
            self.sex = sexType(rawValue: index)
        }
        
        
    }
    
    class func currentId() -> String {
        
        return Auth.auth().currentUser!.uid
    }
    
    
}
