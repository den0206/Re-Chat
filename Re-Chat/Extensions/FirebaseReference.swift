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
    case Tweet
}

func firebaseReference(_ reference : References) -> CollectionReference {
    return Firestore.firestore().collection(reference.rawValue)
}

func tweetReplyReference(tweetId : String) -> CollectionReference {
    return firebaseReference(.Tweet).document(tweetId).collection(kRETWEETS)
}


func tweetLikedReference(tweetId : String) -> CollectionReference {
    firebaseReference(.Tweet).document(tweetId).collection(kLIKES)
}
