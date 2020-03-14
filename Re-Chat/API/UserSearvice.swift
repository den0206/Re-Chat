//
//  UserSearvice.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/14.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Firebase

struct UserSearvice {
    
    static let shared = UserSearvice()
    
    func fetchUsers(completion : @escaping([User]) -> Void) {
        var users = [User]()
        
        firebaseReference(.User).getDocuments { (snapshot, error) in
            
            guard let snapshot = snapshot else {return}
            
            if !snapshot.isEmpty {
                for document in snapshot.documents {
                    let dictionary = document.data()
                    
                    // except currentuser
                    if document.documentID != User.currentId() {
                        let user = User(uid: document.documentID, dictionary: dictionary)
                        users.append(user)
                    }
                    
                    
                }
                completion(users)
            }
        }
    }
    
}
