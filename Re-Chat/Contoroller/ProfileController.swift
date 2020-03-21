//
//  ProfileController.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/15.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

private let headerIdentifer = "ProfileHeader"

class ProfileController : UICollectionViewController {
    
    private var user :User
    
    
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
        
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifer)
        
        
    }
    
    
    
}

//MARK: - Collectionview delegate

extension ProfileController {
    
    
    // for header
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifer, for: indexPath) as! ProfileHeader
        
        header.user = user
        header.delegate = self
        return header
    }
}

extension ProfileController : UICollectionViewDelegateFlowLayout {
    
    // header size
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }
}

//MARK: - take Delegate Area

extension ProfileController : ProfileHeaderDelegate {
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    
}


