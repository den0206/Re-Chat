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
    case Recent
    case Message
}

func firebaseReference(_ reference : References) -> CollectionReference {
    return Firestore.firestore().collection(reference.rawValue)
}

//MARK: - Status Col

func followingRefernce(uid : String) -> CollectionReference {
    return firebaseReference(.User).document(uid).collection(kFOLLOWING)
}

func followersRefernce(uid : String) -> CollectionReference {
    return firebaseReference(.User).document(uid).collection(kFOLLOWERS)
}

//MARK: - Retweet col

func tweetReplyReference(tweetId : String) -> CollectionReference {
    return firebaseReference(.Tweet).document(tweetId).collection(kRETWEETS)
}

//MARK: - Like col

func tweetLikedReference(tweetId : String) -> CollectionReference {
    firebaseReference(.Tweet).document(tweetId).collection(kLIKES)
}
