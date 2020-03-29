//
//  dounloader.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/14.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import AVFoundation
import MBProgressHUD

//MARK: - downloaders use MessageVC

let storage = Storage.storage()

// image

func uploadImage(image : UIImage, chatRoomId : String, view : UIView, completion : @escaping(_ imageLink : String?, _ error : Error?) -> Void) {
    
    let MB = MBProgressHUD.showAdded(to: view, animated: true)
    MB.mode = .determinateHorizontalBar
    
    let dateString = dateFormatter().string(from: Date())
    let photoFileName = "PictureMessages/" + User.currentId() + "/" + chatRoomId + "/" + dateString + ".jpg"
    
    let storageRef = storage.reference(forURL: kFILEREFERENCE).child(photoFileName)
    
    // encode image data
    let imageData = image.jpegData(compressionQuality: 0.3)
    var task : StorageUploadTask!
    
    task = storageRef.putData(imageData!, metadata: nil, completion: { (metadata, error) in
        
        task.removeAllObservers()
        MB.hide(animated: true)
        
        if error != nil {
            print(error!.localizedDescription)
            completion(nil, error)
            return
        }
        
        storageRef.downloadURL { (url, error) in
            
            guard let downloadUrl = url else {
                completion(nil, error)
                return}
            
            completion(downloadUrl.absoluteString, nil)
        }
        
        
    })
    
    task.observe(StorageTaskStatus.progress) { (snapshot) in
        MB.progress = Float((snapshot.progress?.completedUnitCount)!) / Float((snapshot.progress?.totalUnitCount)!)
        
        
    }
}

func downLoadImageFromString(imageLink : String) -> UIImage?{
    let imageUrl = NSURL(string: imageLink)
    let imageFileName = (imageLink.components(separatedBy: "%").last!).components(separatedBy: "?").first!
    
    // check Exist
    if fileExistPath(path: imageLink) {
        
        if let componentsFile = UIImage(contentsOfFile: fileInDocumentDictionary(filename: imageFileName)) {
            return componentsFile
        } else {
            return nil
        }
    } else {
        let nsData = NSData(contentsOf: imageUrl! as URL)
        
        if nsData != nil {
            // add To documentsUrl
            var docURL = getDocumentUrl()
            
            docURL = docURL.appendingPathComponent(imageFileName, isDirectory: false)
            nsData!.write(to: docURL, atomically: true)
            
            let imageToReturn = UIImage(data: nsData! as Data)
            return imageToReturn
            
        } else {
            print("No Image Database")
            return nil
        }
    }

    
}

// video

func uploadVideo(video : NSData, chatRoomId : String, view : UIView, completion :  @escaping(_ videoLink : String?) -> Void) {
    
    let MB = MBProgressHUD.showAdded(to: view, animated: true)
       MB.mode = .determinateHorizontalBar
    
    let dateString = dateFormatter().string(from: Date())
    let videoFileName = "VideoMessages/" + User.currentId() + "/" + chatRoomId + "/" + dateString + ".mov"
    
    let strogeRef = storage.reference(forURL: kFILEREFERENCE).child(videoFileName)
    var task : StorageUploadTask!
    
    task = strogeRef.putData(video as Data, metadata: nil, completion: { (metaData, error) in
        
        task?.removeAllObservers()
        MB.hide(animated: true)
        
        if error != nil {
            print(error!.localizedDescription)
            return
        }
        
        strogeRef.downloadURL { (url, error) in
            
            guard let downloadUrl = url else {
                completion(nil)
                return}
            
            completion(downloadUrl.absoluteString)
        }
    })
    
    task.observe(StorageTaskStatus.progress) { (snapshot) in
        MB.progress = Float((snapshot.progress?.completedUnitCount)!) / Float((snapshot.progress?.totalUnitCount)!)
    }
    
}

func downloadVideo(videoLink: String, completion :  @escaping(_ isReadyTpPlay :Bool, _ videoFileName : String) -> Void) {
    
    let videoURL = NSURL(string: videoLink)
    let videoFileName = (videoLink.components(separatedBy: "%").last!).components(separatedBy: "?").first!
    
    if fileExistPath(path: videoFileName) {
        completion(true, videoFileName)
    } else {
        
        let downloadQue = DispatchQueue(label: "videoDownloadQueue")
        downloadQue.async {
            
            let data =  NSData(contentsOf: videoURL! as URL)
            
            if data != nil {
                var docUrl = getDocumentUrl()
                
                docUrl = docUrl.appendingPathComponent(videoFileName, isDirectory: false)
                data!.write(to: docUrl, atomically: true)
                
                DispatchQueue.main.async {
                    completion(true , videoFileName)
                }
            } else {
                DispatchQueue.main.async {
                    print("No Video In DB")
                }
            }
        }
    }
}




//MARK: - Decode Image

func imageFromData(pictureData : String, withBlock : (_ image : UIImage?) -> Void) {
    
    var image : UIImage?
    
    let decodesdData = NSData(base64Encoded: pictureData, options: NSData.Base64DecodingOptions(rawValue: 0))
    
    image = UIImage(data: decodesdData! as Data)
    
    withBlock(image)
}


func dataImageFromString(picString : String, withBlock : (_ image : Data?) -> Void) {
    let imageData = NSData(base64Encoded: picString, options: NSData.Base64DecodingOptions(rawValue: 0))
    
    withBlock(imageData as Data?)
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

func videoThmbnail(video: NSURL) -> UIImage {
    
    let asset = AVURLAsset(url: video as URL, options: nil)
    
    let imageGenerator = AVAssetImageGenerator(asset: asset)
    imageGenerator.appliesPreferredTrackTransform = true
    
    let time = CMTime(seconds: 0.5, preferredTimescale: 1000)
    var actualTime = CMTime.zero
    
    var image : CGImage?
    
    do {
        image = try imageGenerator.copyCGImage(at: time, actualTime: &actualTime)
    } catch let error as NSError {
        print(error.localizedDescription)
    }
    
    let thunmbnail = UIImage(cgImage: image!)
    
    return thunmbnail
}
