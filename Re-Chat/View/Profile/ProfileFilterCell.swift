//
//  ProfileFilterCell.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/21.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class ProfileFilterCell : UICollectionViewCell {
    
    var option : ProfileFilterOption? {
        didSet {
            guard let option = option else {return}
            titleLabel.text = option.description
        }
    }
    
    //MARK: - Parts
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Loading"
        return label
        
    }()
    
    override var isSelected: Bool {
        didSet {
            titleLabel.font = isSelected ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 14)
            titleLabel.textColor = isSelected ? .lightGray : .black
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addSubview(titleLabel)
        titleLabel.center(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
}
