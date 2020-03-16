//
//  NewsViewController.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/16.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import SegementSlide

class NewsViewController : SegementSlideViewController {
    
    //MARK: - Lify cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadData()
        scrollToSlide(at: 0, animated: false)
    }
    
    
    override var headerView: UIView? {
        let headerView = UIImageView()
        headerView.isUserInteractionEnabled = true
        headerView.contentMode = .scaleAspectFill
        headerView.image = UIImage(named: "header")
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.heightAnchor.constraint(equalToConstant: view.bounds.height/4).isActive = true
        
        return headerView
        
//        return UIView()
     }

     override var titlesInSwitcher: [String] {
         return ["Swift", "Ruby", "Kotlin"]
     }

     override func segementSlideContentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
         
        switch index {
        case 0 :
            return Page1()
        case 1 :
            return Page1()
        case 2 :
            return Page1()
        case 3 :
            return Page1()
        case 4 :
            return Page1()
        case 5 :
            return Page1()
            
        default:
            return Page1()
        }
     }
    
}
