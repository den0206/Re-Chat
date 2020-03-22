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
    
    private var tweets = [Tweet]()
    private var likedTweets = [Tweet]()
    private var replyTweet = [Tweet]()
    
    private var currentTweets : [Tweet] {
        switch selectedFilter {
            
        case .tweet:
            return tweets
        case .reply:
            return likedTweets
        case .like:
            return replyTweet
       
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
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
        
        return CGSize(width: view.frame.width, height: 120)
       }
    
    // header size
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }
}

//MARK: - take Delegate Area

extension ProfileController : ProfileHeaderDelegate {
    func didSelect(filter: ProfileFilterOption) {
        // pass filter
        self.selectedFilter = filter
        
        print(currentTweets.count)
    }
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    
}


