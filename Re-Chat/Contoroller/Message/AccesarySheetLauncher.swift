//
//  AccesarySheetLauncher.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/29.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

protocol AccesarySheetLauncherDelegate : class {
    func handleDismiss(view : AccesarySheetLauncher)
}

class AccesarySheetLauncher : NSObject {
    
    let tableview = UITableView()
    private var window : UIWindow?
    
    private var tableViewHeight : CGFloat?
    var inputBarHeight : CGFloat?
    
    var delegate : AccesarySheetLauncherDelegate?
    
    //MARK: - Parts
    lazy var blackView : UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
        view.addGestureRecognizer(tap)
        
        return view
    }()
    
    private lazy var footerView : UIView = {
        let view = UIView()
        view.addSubview(cancelButton)
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.anchor(left : view.leftAnchor, right: view.rightAnchor,paddingLeft: 12,paddingRight: 12)
        cancelButton.centerY(inView: view)
        cancelButton.layer.cornerRadius = 50 / 2
        
        return view
    }()
    
    private lazy var cancelButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGroupedBackground
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
   
    override init() {
        super.init()
        
        configureTableView()
    }
    
    private func configureTableView() {
        tableview.backgroundColor = .white
        tableview.delegate = self
        tableview.dataSource = self
        
        tableview.rowHeight = 60
        tableview.separatorStyle = .none
        tableview.layer.cornerRadius = 5
        tableview.isScrollEnabled = false
        
        
    }
    //MARK: - Show options
    
    func show() {
        guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else {return}
        
        self.window = window
        
        window.addSubview(blackView)
        blackView.frame = window.frame
        
        
        
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 1
        }
    }
    
    
    //MARK: - Actions
    
    @objc func handleDismiss() {
        delegate?.handleDismiss(view: self)

    }
}

extension AccesarySheetLauncher : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AccesarySheetOptions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
