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

struct UserRelationStats {
    var followers : Int
    var following : Int
}

class User {
    
    let email : String
    var fullname : String
    let uid : String
    let profileImage : String
    var sex : sexType!
    
    var stats : UserRelationStats?
    var isFollewed = false
    var isCurrentUser : Bool {
        return Auth.auth().currentUser?.uid == uid
    }
    
    
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
    
    //MARK: - Follow func
    
    func follow() {
        let date = Int(NSDate().timeIntervalSince1970)
        guard let currentId = Auth.auth().currentUser?.uid else {return}
        
        followingRefernce(uid: currentId).document(self.uid).setData([kTIMESTAMP : date])
        followersRefernce(uid: self.uid).document(currentId).setData([kTIMESTAMP : date])
        
        // increment
        firebaseReference(.User).document(currentId).updateData([kFOLLOWING : FieldValue.increment((Int64(1)))])
        firebaseReference(.User).document(self.uid).updateData([kFOLLOWERS : FieldValue.increment((Int64(1)))])
    }
    
    func unFollow() {
         guard let currentId = Auth.auth().currentUser?.uid else {return}
        
        followingRefernce(uid: currentId).document(self.uid).delete()
        followersRefernce(uid: self.uid).document(currentId).delete()
        
        firebaseReference(.User).document(currentId).updateData([kFOLLOWING : FieldValue.increment((Int64(-1)))])
        firebaseReference(.User).document(self.uid).updateData([kFOLLOWERS : FieldValue.increment((Int64(-1)))])
    }
    
    
}
