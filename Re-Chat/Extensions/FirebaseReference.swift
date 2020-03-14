//
//  FirebaseReference.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/14.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import FirebaseFirestore

enum References : String {
    case User
}

func firebaseReference(_ reference : References) -> CollectionReference {
    return Firestore.firestore().collection(reference.rawValue)
}