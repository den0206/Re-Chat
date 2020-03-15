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


func downloadImageFromData(picturedata : String) -> UIImage?{
    let imageFileName = (picturedata.components(separatedBy: "%").last!).components(separatedBy: "?").first!
    
    if fileExistPath(path: imageFileName) {
        // exist cache
        
        if let contentsOfFile = UIImage(contentsOfFile: fileInDocumentDictionary(filename: imageFileName)) {
            
             return contentsOfFile
        } else {
            print("No Cache")
            return nil
        }
        
    } else {
        // no cache
        
        let data = NSData(base64Encoded: imageFileName, options: NSData.Base64DecodingOptions(rawValue: 0))
        
        if data != nil {
            
            // for cache
            var docUrl = getDocumentUrl()
            
            docUrl = docUrl.appendingPathComponent(imageFileName, isDirectory: false)
            data!.write(to: docUrl, atomically: true)
            
            //
            
            return UIImage(data: data! as Data)
        } else {
            print("No Image")
            return nil
        }
        
    }

}

func getDocumentUrl() -> URL {
    let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
    return documentUrl!
}


func fileInDocumentDictionary(filename : String) -> String{
    let fileUrl = getDocumentUrl().appendingPathComponent(filename)
    
    return fileUrl.path
}

func fileExistPath(path : String) -> Bool {
    var exist : Bool
    
    let filePath = fileInDocumentDictionary(filename: path)
    let fileManager = FileManager.default
    
    if fileManager.fileExists(atPath: filePath) {
        exist = true
    } else {
        exist = false
    }
    
    return exist
    
}
