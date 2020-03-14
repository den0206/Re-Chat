//
//  dounloader.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/14.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation
import UIKit

//MARK: - Decorde Image

func imageFromData(pictureData : String, withBlock : (_ image : UIImage?) -> Void) {
    
    var image : UIImage?
    
    let decodesdData = NSData(base64Encoded: pictureData, options: NSData.Base64DecodingOptions(rawValue: 0))
    
    image = UIImage(data: decodesdData! as Data)
    
    withBlock(image)
}
