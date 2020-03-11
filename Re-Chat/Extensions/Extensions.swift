//
//  Extensions.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/11.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

extension UIView {
    
    func anchor(top : NSLayoutYAxisAnchor? = nil, left : NSLayoutXAxisAnchor? = nil, bottom :NSLayoutYAxisAnchor? = nil, right : NSLayoutXAxisAnchor? = nil, paddongTop : CGFloat = 0, paddingLeft : CGFloat = 0, paddiongBottom : CGFloat = 0, paddingRight : CGFloat = 0, width : CGFloat? = nil, height : CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddongTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddiongBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    // set Dimension
    
    func setDimension(width : CGFloat, height : CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
}

extension UIColor {
       static let backGroundColor = UIColor.init(red: 25/255, green: 25/255, blue: 25/255, alpha: 1)
}
