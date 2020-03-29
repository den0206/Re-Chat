//
//  TweetViewController.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/29.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

private let reuseIdentifer = "TweetCell"
private let headerIdentifer = "TweetHeader"

class TweetViewController : UICollectionViewController {
    
    private let tweet : Tweet
    private var replies : [Tweet] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    init(tweet : Tweet) {
        self.tweet = tweet
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       configureCollectionView()
        fetchReply()
    }
    
    //MARK: - configure UI
    private func configureCollectionView() {
        collectionView.backgroundColor = .white
        
        collectionView.register(TweetHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifer)
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifer)
        
    }
    
    //MARK: - API
    private func fetchReply() {
        
        TweetService.shared.fetchReply(tweetId: tweet.tweetId) { (replies) in
            self.replies = replies
            print( self.replies.count)
        }
        
    }
}

//MARK: - Collectionview Delegate

extension TweetViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return replies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifer, for: indexPath) as! TweetCell
        
        cell.tweet = replies[indexPath.item]
        return cell
    }
    
    // reuse header
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifer, for: indexPath) as! TweetHeader
        
        header.backgroundColor = .red
        return header
    }
}

extension TweetViewController : UICollectionViewDelegateFlowLayout {
    
    // header Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let viewmodel = TweetViewModel(tweet: tweet)
        let captionSize = viewmodel.size(forWidth: view.frame.width).height
        
        return CGSize(width: view.frame.width, height: captionSize + 260)
    }
    
    // cell size(like TableView)
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let viewModel = TweetViewModel(tweet: replies[indexPath.item])
        let captionSize = viewModel.size(forWidth: view.frame.width).height

        
        return CGSize(width: view.frame.width, height: captionSize + 80)
    }
}
