//
//  FeedViewController.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/11.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

protocol FeedControllerDelegate {
    func handleMenuToggle()
}

class FeedController : UICollectionViewController {
    
    var delegate : FeedControllerDelegate?
    
    
    //MARK: - Parts
    
    private let sideMenuButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_menu_black_36dp").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleTappSideMenuButton), for: .touchUpInside)
        return button
    }()
    
    init() {
          super.init(collectionViewLayout: UICollectionViewFlowLayout())
      }
      
      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configiureUI()
        
    }
    
    //MARK: - UI
    
    private func configiureUI() {
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
        
        view.addSubview(sideMenuButton)
        sideMenuButton.anchor(top : view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddongTop: 16, paddingLeft: 20,width: 30,height: 30)
    }
    
    //MARK: - Actions
    
    @objc func handleTappSideMenuButton() {
        
        delegate?.handleMenuToggle()
        
        
    }
    
 
  
}
