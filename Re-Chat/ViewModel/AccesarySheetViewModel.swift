//
//  AccesarySheetViewModel.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/29.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit


enum AccesarySheetOptions : CaseIterable {
    case camera
    case photo
    case video
    case location
    
    var description : String {
        
        switch self {
        
        case .camera:
            return "CAMERA"
        case .photo:
            return "PHOTO"
        case .video:
            return "VIDEO"
        case .location:
            return "LOCATION"
        }
    }
    
    var image : UIImage {
        switch self {
            
        case .camera:
            return #imageLiteral(resourceName: "camera")
        case .photo:
            return #imageLiteral(resourceName: "picture")
        case .video:
            return #imageLiteral(resourceName: "video")
        case .location:
            return #imageLiteral(resourceName: "location")
        }
    }
}
