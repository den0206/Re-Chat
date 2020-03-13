//
//  LoginController.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/12.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class LoginViewController : UIViewController {
    
    
    //MARK: - Parts
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Login"
        label.font = UIFont(name: "Avenir-Light", size: 36)
        label.textColor = UIColor(white: 1, alpha: 0.8)
        return label
    }()
    
    private lazy var emailContainerView : UIView = {
        return inputContainerView(withImage: #imageLiteral(resourceName: "mail"), textField: emailTextfiled)
        
    }()
    
    private lazy var emailTextfiled : UITextField = {
           return makeTextField(withPlaceholder: "Email", isSecureType: false)
       }()
       
    
    private lazy var passwordContainerView : UIView = {
        return inputContainerView(withImage: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: passwordTextfield)
        
    }()
    
    private lazy var passwordTextfield : UITextField = {
        return makeTextField(withPlaceholder: "Password", isSecureType: true)
    }()
    
    private let loginButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .lightGray
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        return button
    }()
    
    let dontHaveAccountButton : UIButton  = {
        let button = UIButton(type: .system)
        let attributeTitle = NSMutableAttributedString(string: "アカウントを持っていませんか？ ", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        attributeTitle.append(NSMutableAttributedString(string: "Sign up", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSMutableAttributedString.Key.foregroundColor : UIColor.lightGray]))
        
        button.setAttributedTitle(attributeTitle, for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
        
    }()
    
    
   
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // hide navigation
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    private func configureUI() {
        view.backgroundColor = .backGroundColor
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top : view.safeAreaLayoutGuide.topAnchor)
        titleLabel.centerX(inView: view)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton])
        
        stack.axis = .vertical
        stack.distribution = .fillEqually
        
        stack.spacing = 24
        
        view.addSubview(stack)
        
        stack.centerY(inView: view)
        stack.anchor(left: view.leftAnchor, right: view.rightAnchor, paddongTop: 40, paddingLeft: 16, paddingRight: 16)
        
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inView: view)
        dontHaveAccountButton.anchor(bottom : view.bottomAnchor, paddiongBottom:  12)
        
        
    }
    
    //MARK: - Actions
    
    @objc func handleLogin() {
        print("Login")
    }
    
    @objc func handleSignUp() {
        let controller = SignUpController()
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    
 
}

//MARK: - Heplers

extension LoginViewController {
    
    func inputContainerView(withImage : UIImage, textField : UITextField? = nil) -> UIView {
         
         let view = UIView()
         
         let iv = UIImageView()
         iv.image = withImage
         iv.tintColor = .white
         iv.alpha = 0.87
         view.addSubview(iv)
         
         if let textField = textField {
             iv.centerY(inView: view)
             iv.anchor(left : view.leftAnchor, paddingLeft: 8, width: 24, height: 24)
             
             view.addSubview(textField)
             textField.centerY(inView: view)
             textField.anchor(left : iv.rightAnchor, bottom:  view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, paddiongBottom: 8)
         }
         
         let separatorVIew = UIView()
         separatorVIew.backgroundColor = .white
         view.addSubview(separatorVIew)
         separatorVIew.anchor(left : view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, height: 0.75)
         
         return view
     }
     
     func makeTextField(withPlaceholder : String, isSecureType : Bool) -> UITextField {
         let tf = UITextField()
         tf.borderStyle = .none
         tf.font = UIFont.systemFont(ofSize: 16)
         tf.textColor = .white
         tf.keyboardAppearance = .dark
         tf.isSecureTextEntry = isSecureType
         tf.attributedPlaceholder = NSAttributedString(string: withPlaceholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
         tf.autocapitalizationType = .none
         
         return tf
     }
    
}
