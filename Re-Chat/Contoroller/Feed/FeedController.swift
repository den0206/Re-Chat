//
//  FeedViewController.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/11.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

protocol FeedControllerDelegate {
    func handleMenuToggle()
}

private let reuserIdentifer = "FeedCell"

class FeedController : UICollectionViewController {
    
    var delegate : FeedControllerDelegate?
    
    var user : User?
    
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
    
    
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCV()
        
        fetchTweets()
        
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
        
        view.addSubview(sideMenuButton)
        sideMenuButton.anchor(top : view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddongTop: 16, paddingLeft: 20,width: 30,height: 30)
        
        view.addSubview(actionButton)
        actionButton.anchor( bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddiongBottom: 64, paddingRight: 16, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56 / 2
    }
    
    //MARK: - API
    
    private func fetchTweets() {
        TweetService.shared.fetchAllTweets { (tweets) in
            self.tweets = tweets.sorted(by: { $0.timestamp > $1.timestamp })
            
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
    
    func handleRetweetTapped(cell: TweetCell) {
        // Retweet config
        
        guard let tweet = cell.tweet else {return}
        print(tweet)
        let replyVC = UploadTweetController(user: tweet.user, config: .reply(tweet))
        
        let nav = UINavigationController(rootViewController: replyVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
        
    }
    
    
}
