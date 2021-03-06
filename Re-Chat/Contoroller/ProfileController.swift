//
//  ProfileController.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/15.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

private let reuserIdentifer = "TweetCell"
private let headerIdentifer = "ProfileHeader"

class ProfileController : UICollectionViewController {
    
    private var user :User
    
    private var selectedFilter : ProfileFilterOption = .tweet {
        didSet {
            
            collectionView.reloadData()
        }
    }
    
    private var tweets = [Tweet]() {
        didSet {
            collectionView.reloadData()
        }
    }
    private var likedTweets = [Tweet]()
    private var replyTweets = [Tweet]()
    
    private var currentTweets : [Tweet] {
       
        switch selectedFilter {
            
        case .tweet:
            return tweets
        case .reply:
            return replyTweets
        case .like:
            return likedTweets
       
        }
    }
    
    init(user : User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        fetchTweetsSpecificUser()
        
        fetchReply()
        fetchLikes()
        
        // status
        checkUserIsFollow()
        checkUserStatus()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.isHidden = true

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.navigationBar.isHidden = false
        
    }
    //MARK: - Hekpers
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuserIdentifer)
        
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifer)
        
        
    }
    
    //MARK: - fire Store (set )
    
    private func fetchTweetsSpecificUser() {
        
        TweetService.shared.fetchTweetSpecificUser(user: user) { (tweets) in
            self.tweets = tweets.sorted(by: { $0.timestamp > $1.timestamp })
            
            // check didLike
            self.tweets.forEach { (tweet) in
                
                TweetService.shared.checkIfUserLikedTweet(tweet) { (didlike) in
                    
                    guard didlike == true else {return}
                    
                    if let index = self.tweets.firstIndex(where: {$0.tweetId == tweet.tweetId}) {
                        self.tweets[index].didLike = true
                    }
                }
            }
        }
    }
    
    private func fetchReply() {
        TweetService.shared.fetchReply(user: user) { (reply) in
            self.replyTweets = reply.sorted(by: { $0.timestamp > $1.timestamp })
            
            // check didLike

            self.replyTweets.forEach { (tweet) in
                
                TweetService.shared.checkIfUserLikedTweet(tweet) { (didlike) in
                    
                    guard didlike == true else {return}
                    
                    if let index = self.replyTweets.firstIndex(where: {$0.tweetId == tweet.tweetId}) {
                        self.replyTweets[index].didLike = true
                    }
                }
            }
            
        }
    }
    
    private func fetchLikes() {
        TweetService.shared.fetchLikes(user: user) { (like) in
            self.likedTweets = like.sorted(by: { $0.timestamp > $1.timestamp })
            
          
            // already Check did like
        }
    }
    
    private func checkUserIsFollow() {
        UserSearvice.shared.checkUsetIsFollow(uid: user.uid) { (follow) in
            self.user.isFollewed = follow
            // for config button & label (add snapshot listner)
            self.collectionView.reloadData()
        }
    }
    
    private func checkUserStatus() {
        UserSearvice.shared.fetchUserStats(uid: user.uid) { (status) in
            
            self.user.stats = status
            // for config button & label (add snapshot listner)
            self.collectionView.reloadData()
        }
    }
    
}

//MARK: - Collectionview delegate & Flowlayout Delgate

extension ProfileController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentTweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuserIdentifer, for: indexPath) as! TweetCell
        
        cell.tweet = currentTweets[indexPath.item]
        cell.delegate = self
        
        return cell
    }
    
    
    // for header
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifer, for: indexPath) as! ProfileHeader
        
        header.user = user
        header.delegate = self
        return header
    }
    
   
}

extension ProfileController : UICollectionViewDelegateFlowLayout {
    
    // cell size
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let vm = TweetViewModel(tweet: currentTweets[indexPath.item])
        let captionSize = vm.size(forWidth: view.frame.width).height
        
        
        return CGSize(width: view.frame.width, height: captionSize + 72)
    }
    
    // header size
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }
}

//MARK: - take Delegate Area

extension ProfileController : ProfileHeaderDelegate {
    
    func handleEditProfileFollow(header: ProfileHeader) {
        if user.isCurrentUser {
            print("Edit")
            return
        }
        
        if user.isFollewed {
            // unfollow
            user.unFollow()
            user.isFollewed = false
        } else {
            // follow
            user.follow()
            user.isFollewed = true
            
            // add Notification
        }
    }
    
    func didSelect(filter: ProfileFilterOption) {
        // pass filter
        self.selectedFilter = filter
        
        print(currentTweets.count)
    }
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    
}

extension ProfileController : TweetCellDelegate {
    func handleRetweetTapped(cell: TweetCell) {
        print("Retweet")
    }
    
    func handleLikeTapped(cell: TweetCell) {
        print("Like")
    }
    
    func handleTappedProfile(cell: TweetCell) {
        guard let user = cell.tweet?.user else {return}
        
        let profileVC = ProfileController(user: user)
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    
}

