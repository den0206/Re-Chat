//
//  AccesarySheetCell.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/29.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class AccesarySheetCell : UITableViewCell {
    
    //MARK: - Vars
    var option : AccesarySheetOptions? {
        didSet {
            configure()
        }
    }
    
    //MARK: - Parts
    
    private let optionImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimension(width: 36, height: 36)
        return iv
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(optionImageView)
        optionImageView.centerY(inView: self)
        optionImageView.anchor(left : leftAnchor, paddingLeft: 8)
        
        addSubview(titleLabel)
        titleLabel.centerY(inView: optionImageView)
        titleLabel.anchor(left : optionImageView.rightAnchor,paddingLeft: 12)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        optionImageView.image = option?.image
        
        titleLabel.text = option?.description
        
    }
}
