//
//  AuthSearvice.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/14.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import FirebaseAuth

enum sexType : Int {
    case man
    case woman
}

struct AuthCredentials {
    
    let email : String
    let fullname : String
    let sex : Int
    let profileImage : String
    let password : String
    
}

class AuthSearvice {
    
    static let shared = AuthSearvice()
    
    func registerUser(credential : AuthCredentials, completion : @escaping(Error?) -> Void) {
        
        let email = credential.email
        let fullname = credential.fullname
        let avatar = credential.profileImage
        let sex = credential.sex
        let password = credential.password
        
        print(sex)
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in

            if error != nil {
                completion(error)
                return
            }

            guard let uid = result?.user.uid else {return}

            let values  = [kEMAIL : email,
                           kPASSWORD : password,
                           kFULLNAME : fullname,
                           kPROFILE_IMAGE : avatar,
                           kSEX : sex,
                           kUSERID : uid] as [String : Any]

            firebaseReference(.User).document(uid).setData(values, completion: completion)


        }
        
        
        
    }
    
    
    
}
