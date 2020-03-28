//
//  File.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/13.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation
import FirebaseFirestore

private let dateFormat = "yyyyMMddHHmmss"
  
let legitType = [kAUDIO, kVIDEO, kLOCATION, kTEXT, kPICTURE]

func dateFormatter() -> DateFormatter {
    
    let dateFormatter = DateFormatter()
    
    dateFormatter.timeZone = TimeZone(secondsFromGMT: TimeZone.current.secondsFromGMT())
    
    dateFormatter.dateFormat = dateFormat
    
    return dateFormatter
}


func isValidEmail(_ string: String) -> Bool {
       let emailRegEx = "[A-Z0-9a-z._+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
       let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
       let result = emailTest.evaluate(with: string)
       return result
}

func timeElapsed(date: Date) -> String {
    
    let seconds = NSDate().timeIntervalSince(date)
    
    var elapsed: String?
    
    
    if (seconds < 60) {
        elapsed = "Just now"
    } else if (seconds < 60 * 60) {
        let minutes = Int(seconds / 60)
        
        var minText = "min"
        if minutes > 1 {
            minText = "mins"
        }
        elapsed = "\(minutes) \(minText)"
        
    } else if (seconds < 24 * 60 * 60) {
        let hours = Int(seconds / (60 * 60))
        var hourText = "hour"
        if hours > 1 {
            hourText = "hours"
        }
        elapsed = "\(hours) \(hourText)"
    } else {
        let currentDateFormater = dateFormatter()
        currentDateFormater.dateFormat = "dd/MM/YYYY"
        
        elapsed = "\(currentDateFormater.string(from: date))"
    }
    
    return elapsed!
}

func dictionaryFromSnapshots(snapshots : [DocumentChange]) -> [NSDictionary] {
    
    var allMassages : [NSDictionary] = []
    
    for diff in snapshots {
        if (diff.type == .added) {
            let dic = diff.document.data() as NSDictionary
            if let type = dic[kTYPE] {
                if legitType.contains(type as! String) {
                    allMassages.append(dic)
                }
                
            }
            
        }
        
    }
    return allMassages
}
