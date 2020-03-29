//
//  FeedViewController.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/11.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import FirebaseFirestore

protocol FeedControllerDelegate {
    func handleMenuToggle()
}

private let reuserIdentifer = "FeedCell"

class FeedController : UICollectionViewController {
    
    var delegate : FeedControllerDelegate?
    
    var user : User?
    var lastDocument : DocumentSnapshot? = nil
    
    let followingRef = followingRefernce(uid: User.currentId())
    var followingListner : ListenerRegistration?
    
    var followingIds = [User.currentId()] {
        didSet {
            
            // after set followingIds get relation Tweets
            fetchFirstFeeds()
        }
    }

    
    private var tweets = [Tweet]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    //MARK: - Parts
    
    // Side Menu
    
    private let sideMenuButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_menu_black_36dp").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleTappSideMenuButton), for: .touchUpInside)
        return button
    }()
    
    // New Tweet
    
    let actionButton : UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .lightGray
        button.setImage(#imageLiteral(resourceName: "new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(handleTappedNewTweet), for: .touchUpInside)
        
        return button
    }()
    
    deinit {
        followingListner?.remove()
    }
    
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCV()
        
        getFollowing()
       
        
//        fetchTweets()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
        
    }
    
    //MARK: - UI
    
    private func configureCV() {
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuserIdentifer)

        view.addSubview(actionButton)
        actionButton.anchor( bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddiongBottom: 64, paddingRight: 16, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56 / 2
        
        // set refresh Controller
        let refreshController = UIRefreshControl()
        refreshController.addTarget(self, action: #selector(handleRefresh(_ :)), for: .valueChanged)
        collectionView.refreshControl = refreshController
        
        // replace containerVC nav left button
        //        view.addSubview(sideMenuButton)
        //        sideMenuButton.anchor(top : view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddongTop: 16, paddingLeft: 20,width: 30,height: 30)
    }
    
    //MARK: - API
    
    func getFollowing(){
        
        followingListner = UserSearvice.shared.fetchFollowingIDs(uid: User.currentId(), completion: { (following) in
            
            self.followingIds = following
            
        })

    }
    
    
    private func fetchFirstFeeds() {
        
        TweetService.shared.getFeeds(userIds: self.followingIds, limit: 8, lastDocument: nil) { (tweets, lastDoc) in
            
            self.tweets = tweets.sorted(by: {$0.timestamp > $1.timestamp})
            self.lastDocument = lastDoc
            
            self.collectionView.refreshControl?.endRefreshing()
        
        }

    }
    
    private func fetchMoreFeeds() {
        
         guard let lastDocument = lastDocument else {return}
        
        firebaseReference(.Tweet).whereField(kUSERID, in: self.followingIds).order(by: kTIMESTAMP, descending: true).start(afterDocument: lastDocument).limit(to: 8).getDocuments { (snapshot, error) in
            
            guard let snapshot = snapshot else {return}
            
            
            
            if !snapshot.isEmpty {
                
                
                for doc in snapshot.documents {
                    let dictionatry = doc.data()
                    let userId = dictionatry[kUSERID] as! String
                    
                    UserSearvice.shared.userIdToUser(uid: userId) { (user) in
                        
                        var tweet = Tweet(user: user, tweetId: doc.documentID, dictionary: dictionatry)
                        
                        
                        TweetService.shared.checkIfUserLikedTweet(tweet) { (didLike) in
                            
                            
                            
                            tweet.didLike = didLike
                            self.tweets.append(tweet)
                           
                            //tweets.sorted(by: {$0.timestamp > $1.timestamp})
                            
                            
                        }
                    }
                }
                let lastDoc = snapshot.documents.last
                self.lastDocument = lastDoc
                
            }
            
        }
    }
    
    

    //MARK: - Actions
    
    @objc func handleTappSideMenuButton() {
        
        delegate?.handleMenuToggle()
        
    }
    
    @objc func handleTappedNewTweet() {
        
        // New tweet config
        guard let user = user else {return}
        
        let uploadVC = UploadTweetController(user: user, config: .tweet)
        
        let nav = UINavigationController(rootViewController: uploadVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
        
    }
    
    @objc func handleRefresh(_ sender : UIRefreshControl) {
        
        self.tweets.removeAll(keepingCapacity: false)
        
        fetchFirstFeeds()
        
    }
    
    
    
}

//MARK: - Colleectionview Delegate

extension FeedController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuserIdentifer, for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.item]
        cell.delegate = self
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let tweet = tweets[indexPath.item]
        
        let tweetVC = TweetViewController(tweet: tweet)
        navigationController?.pushViewController(tweetVC, animated: true)
    }
    
    //MARK: - For pagination
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if tweets.count >= 8 && indexPath.item == (self.tweets.count - 1) {
            
            fetchMoreFeeds()

        }
    }
}

//MARK: - UICollectionView Flowlayout

extension FeedController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let vm = TweetViewModel(tweet: tweets[indexPath.item])
        let captionSize = vm.size(forWidth: view.frame.width).height
        
//        print(captionSize)
        return CGSize(width: view.frame.width, height: captionSize + 72)
    }
    
}

//MARK: - Tweet Cell Delgate

extension FeedController : TweetCellDelegate {
    
    func handleTappedProfile(cell: TweetCell) {
       
        guard let user = cell.tweet?.user else {return}

        let profileVC = ProfileController(user: user)
        navigationController?.pushViewController(profileVC, animated: true)
    }
    

    
    func handleRetweetTapped(cell: TweetCell) {
        // Retweet config
        
        guard let tweet = cell.tweet else {return}
        print(tweet)
        let replyVC = UploadTweetController(user: tweet.user, config: .reply(tweet))
        
        let nav = UINavigationController(rootViewController: replyVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
        
    }
    
    func handleLikeTapped(cell: TweetCell) {
        guard let tweet = cell.tweet else {return}
        
        if tweet.didLike {
            tweet.unlike()
            
            // for sync conf
            cell.likeButton.tintColor = .lightGray
            cell.likeButton.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
            cell.tweet?.didLike = false
        } else {
            tweet.like()
            
            // for sync conf
            cell.likeButton.tintColor = .red
            cell.likeButton.setImage(#imageLiteral(resourceName: "like_filled"), for: .normal)
            cell.tweet?.didLike = true
        }
    }
    
    
    
}



//MARK: - Fetch All Tweets(haven't use)

//    private func fetchTweets() {
//        TweetService.shared.fetchAllTweets { (tweets) in
//
//
//            // check like
//            self.checkifUserLikedTweet()
//
//        }
//    }
//
//    private func checkifUserLikedTweet() {
//        self.tweets.forEach { (tweet) in
//            TweetService.shared.checkIfUserLikedTweet(tweet) { (didLike) in
//                // remove un Like
//                guard didLike == true else {return}
//
//                if let index = self.tweets.firstIndex(where: {$0.tweetId == tweet.tweetId}) {
//                    self.tweets[index].didLike = true
//                }
//            }
//        }
//    }
//
//
