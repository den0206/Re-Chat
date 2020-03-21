//
//  ProfileFilterView.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/21.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

private let reuseIdentifer = "filterCell"

protocol ProfileFilterViewDelegate : class {
    func filterView(didSelect index : Int)
}

class ProfileFilterView : UIView {
    
    var delagate : ProfileFilterViewDelegate?
    
    //MARK: - Parts
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        
        return cv
    }()
    
    private let underLineView : UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    //MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.register(ProfileFilterCell.self, forCellWithReuseIdentifier: reuseIdentifer)
        
        addSubview(collectionView)
        // add frame
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.anchor(top : topAnchor,left: leftAnchor,bottom: bottomAnchor,right: rightAnchor)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        addSubview(underLineView)
        underLineView.anchor(left : leftAnchor,bottom: bottomAnchor, width: frame.width / 3, height: 2)
    }
}

extension ProfileFilterView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProfileFilterOption.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifer, for: indexPath) as! ProfileFilterCell
        
        let option = ProfileFilterOption(rawValue: indexPath.item)
        cell.option = option
        
        return cell
    }
    
    
}

extension ProfileFilterView : UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        let xPosition = cell?.frame.origin.x ?? 0
        
        UIView.animate(withDuration: 0.3) {
            self.underLineView.frame.origin.x = xPosition
        }
        
        delagate?.filterView(didSelect: indexPath.item)
    }
    
}

extension ProfileFilterView : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 3, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


