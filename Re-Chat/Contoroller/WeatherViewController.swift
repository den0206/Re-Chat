//
//  WheatherViewController.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/20.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class WeatherViewController : UIViewController {
    
    //MARK: - parts
    
    private lazy var searchTextField : UITextField = {
        return makeTextField(withPlaceholder: "Search", isSecureType: false)
    }()
    
    private let searchButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "search_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setDimension(width: 20, height: 20)
        button.tintColor = .black
        button.addTarget(self, action: #selector(pressedSearch(_ :)), for: .touchUpInside)
        
        return button
    }()

    
    private let conditionImageview : UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.setDimension(width: 120, height: 120)
        iv.image = #imageLiteral(resourceName: "c02n")
        return iv
    }()
    
    private let templatureLabel : UILabel = {
        let label = UILabel()
        label.text = "20 c"
        label.font = UIFont.boldSystemFont(ofSize: 50)
        return label
    }()
    
    private let citLabel : UILabel = {
         let label = UILabel()
         label.text = "test city"
         label.font = UIFont.systemFont(ofSize: 16)
         return label
     }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
      
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        
        view.backgroundColor = .lightGray
        
        view.addSubview(searchTextField)
        searchTextField.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddongTop: 16, paddingLeft: 16)
        searchTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        searchTextField.delegate = self
        
        
        let separatorVIew = UIView()
        separatorVIew.backgroundColor = .white
        searchTextField.addSubview(separatorVIew)
        separatorVIew.anchor(left : searchTextField.leftAnchor, bottom: searchTextField.bottomAnchor, right: searchTextField.rightAnchor, paddingLeft: 8, height: 0.75)
        
        
        view.addSubview(searchButton)
        searchButton.centerY(inView: searchTextField)
        searchButton.anchor(left : searchTextField.rightAnchor, right: view.rightAnchor, paddingLeft: 8, paddingRight: 8)
        
        view.addSubview(conditionImageview)
        conditionImageview.anchor(top : searchTextField.bottomAnchor, right: view.rightAnchor, paddongTop: 16, paddingRight: 16)
        
        view.addSubview(templatureLabel)
        templatureLabel.anchor(top: conditionImageview.bottomAnchor, right: view.rightAnchor, paddongTop: 16, paddingRight: 16)
        
        view.addSubview(citLabel)
        citLabel.anchor(top : templatureLabel.bottomAnchor, right: view.rightAnchor, paddongTop: 16, paddingRight: 16)
        
  
        
        
    }
    
    //MARK: - Actions
    
    @objc func pressedSearch(_ sender : UIButton) {
        
        
        searchTextField.endEditing(true)
    }
}


extension WeatherViewController {
    
   
        func makeTextField(withPlaceholder : String, isSecureType : Bool) -> UITextField {
            let tf = UITextField()
            tf.borderStyle = .none
            tf.textColor = .white
            tf.font = UIFont.systemFont(ofSize: 16)
            tf.keyboardAppearance = .dark
            tf.isSecureTextEntry = isSecureType
            tf.attributedPlaceholder = NSAttributedString(string: withPlaceholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
            tf.autocapitalizationType = .none
            
            return tf
        }
}

//MARK: - searchTestField Delegate
extension WeatherViewController  : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            print(city)
        }
        
        searchTextField.text = ""
    }
    
}
