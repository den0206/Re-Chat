//
//  WebViewController.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/16.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import WebKit

class WebViewController : UIViewController {
    
    private var webview = WKWebView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureWebView()
        
    }
    
    private func configureWebView() {
        
        
//        webview.frame = view.frame
        webview.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 50)
        self.view.addSubview(webview)
        
        // button
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleDismiss(_ :)), for: .touchUpInside)
        button.setTitle("Back", for: .normal)
        button.frame = CGRect(x: 0, y: self.view.frame.size.height - 50, width: self.view.frame.size.width, height: 50)
        self.view.addSubview(button)
        
        loadURL()
        
    }
    
    private func loadURL() {
        
        let urlStrig  = UserDefaults.standard.object(forKey: "url")
        let url = URL(string: urlStrig! as! String)
        
        let request = URLRequest(url: url!)
        webview.load(request)
        
    }
    
    //MARK: - Actions
    
    @objc func handleDismiss(_ sender : UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
}
extension WebViewController : WKUIDelegate {
    
}
