//
//  SignUpController.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/13.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class SignUpController : UIViewController {
    
    private var selectedImage : UIImage?
    private let imagePicker = UIImagePickerController()
    
    //MARK: - Parts
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Sign Up"
        label.font = UIFont(name: "Avenir-Light", size: 36)
        label.textColor = UIColor(white: 1, alpha: 0.8)
        return label
    }()
    
    private let plusPhotoButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(tappedPlusButton), for: .touchUpInside)
        return button
    }()
    
    // email
    
    private lazy var emailContainerView : UIView = {
        return inputContainerView(withImage: #imageLiteral(resourceName: "mail"), textField: emailTextfiled)
        
    }()
    
    private lazy var emailTextfiled : UITextField = {
        return makeTextField(withPlaceholder: "Email", isSecureType: false)
    }()
    
    // fullname
    
    private lazy var fullnameContainerView : UIView = {
        return inputContainerView(withImage: #imageLiteral(resourceName: "ic_person_outline_white_2x"), textField: fullnameTextfiled)
        
    }()
    
    private lazy var fullnameTextfiled : UITextField = {
        return makeTextField(withPlaceholder: "Fullname", isSecureType: false)
    }()
    
    // sex
    
    private lazy var sexTypeContainerView : UIView = {
        return inputContainerView(withImage: #imageLiteral(resourceName: "ic_person_outline_white_2x"),  segmentControl: sexTypeSegmentControl)
    }()
    
    private lazy var sexTypeSegmentControl : UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Man", "Woman"])
        sc.tintColor = UIColor(white: 1, alpha: 0.87)
        sc.backgroundColor = .backGroundColor
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    
    
    // password
    
    private lazy var passwordContainerView : UIView = {
        return inputContainerView(withImage: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: passwordTextfield)
        
    }()
    
    private lazy var passwordTextfield : UITextField = {
        return makeTextField(withPlaceholder: "Password", isSecureType: true)
    }()
    
    // password confirmation
    
    private lazy var passwordConfirmationContainerView : UIView = {
        return inputContainerView(withImage: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: passwordConfirmationTextfield)
        
    }()
    
    private lazy var passwordConfirmationTextfield : UITextField = {
        return makeTextField(withPlaceholder: "PasswordConfirmation", isSecureType: true)
    }()
    
    private let SignUpButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .lightGray
        button.setTitle("Login", for: .normal)
        button.isEnabled = false
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        return button
    }()
    
    private let alertLabel :UILabel = {
        let label = UILabel()
        label.text = "※項目を埋めてください"
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    let alreadyHaveAccountButton : UIButton  = {
        let button = UIButton(type: .system)
        let attributeTitle = NSMutableAttributedString(string: "アカウントを持ってる方は？ ", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        attributeTitle.append(NSMutableAttributedString(string: "Log in", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSMutableAttributedString.Key.foregroundColor : UIColor.lightGray]))
        
        button.setAttributedTitle(attributeTitle, for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
        
    }()
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        
    }
    private func configureUI() {
        
        view.backgroundColor = .backGroundColor
        
        view.addSubview(titleLabel)
        titleLabel.centerX(inView: view)
        titleLabel.anchor(top : view.safeAreaLayoutGuide.topAnchor)
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view, topAnchor: titleLabel.bottomAnchor, paddingTop: 16)
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
       
        plusPhotoButton.setDimension(width: 150, height: 150)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, fullnameContainerView, sexTypeContainerView, passwordContainerView, passwordConfirmationContainerView, SignUpButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top : plusPhotoButton.bottomAnchor, left : view.leftAnchor, right: view.rightAnchor,paddongTop: 40,paddingLeft: 16, paddingRight: 16)
        
        view.addSubview(alertLabel)
        alertLabel.centerX(inView: view, topAnchor: stack.bottomAnchor, paddingTop: 23)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.centerX(inView: view)
        alreadyHaveAccountButton.anchor(bottom : view.bottomAnchor, paddiongBottom:  12)
        
        addTextfFieldValidation()
   
        
    }
    
    private func addTextfFieldValidation() {
        let tfArray : [UITextField] = [emailTextfiled, fullnameTextfiled,passwordTextfield,passwordConfirmationTextfield]
        
        for tf in tfArray {
            tf.addTarget(self, action: #selector(fillTextField), for: .editingChanged)
            tf.delegate = self
        }
    }
    
    //MARK: - Actions
    
    @objc func tappedPlusButton() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - Sign Up
    
    
    @objc func handleSignUp() {
        // TODO: - Sign Up
        
        guard selectedImage != nil else {
            showAlert(title: "Recheck", message: "画像を選択してください")
            return
        }
        
        guard isValidEmail(emailTextfiled.text!) else {
            showAlert(title: "Recheck", message: "Eメール用の書式を記入ください")
            return
        }
        
        guard passwordTextfield.text == passwordConfirmationTextfield.text else {
            showAlert(title: "Recheck", message: "確認用パスワードが一致しません")
            return
        }
        
//        guard let sex = sexType(rawValue: sexTypeSegmentControl.selectedSegmentIndex) else {return}
        let sex = sexTypeSegmentControl.selectedSegmentIndex
       
        // encode Image
        let avatarData = selectedImage?.jpegData(compressionQuality: 0.3)
        let avatar = avatarData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        showPresentLoadindView(true, message: nil)
        
        
        let credential = AuthCredentials(email: emailTextfiled.text!, fullname: fullnameTextfiled.text!, sex: sex, profileImage: avatar!, password: passwordTextfield.text!)
        
        AuthSearvice.shared.registerUser(credential: credential) { (error) in
            
            if error != nil {
                // hide indicator
                self.showPresentLoadindView(false)
                
                self.showAlert(title: "Recheck", message: error!.localizedDescription)
                
                return
            }
            
            // no error
            
            guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else {return}
            guard let tab = window.rootViewController as? MaintabController else {return}
            
            tab.checkUserIsLogin()
            
            self.dismiss(animated: true) {
                // dismiss Indicator
                self.showPresentLoadindView(false)
            }
            
            
            
        }
    }
    
    @objc func handleLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    
}

//MARK: - Helpers


extension SignUpController {
    
    @objc func fillTextField() {
        // fill Textfield
        guard emailTextfiled.text != "" && fullnameTextfiled.text != "" && passwordTextfield.text != "" && passwordConfirmationTextfield.text != "" else {
            alertLabel.isHidden = false
            
            SignUpButton.isEnabled = false
            SignUpButton.backgroundColor = .lightGray
            return
        }
        
        alertLabel.isHidden = true
        
        SignUpButton.isEnabled = true
        SignUpButton.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        
    }
    
    func inputContainerView(withImage : UIImage, textField : UITextField? = nil, segmentControl : UISegmentedControl? = nil) -> UIView {
        
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
        
        if let sc = segmentControl {
            iv.centerY(inView: view)
            iv.anchor( left : view.leftAnchor, paddingLeft: 8, width: 24, height: 24)
            view.addSubview(sc)
            sc.anchor(left : iv.rightAnchor, right:  view.rightAnchor, paddingLeft:  8, paddingRight: 8)
            sc.centerY(inView: view)
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

//MARK: - Textfield Delegate

extension SignUpController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - ImagePickerDelegate

extension SignUpController : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let profileImage = info[.editedImage] as? UIImage else {return}
        self.selectedImage = profileImage
        
        plusPhotoButton.layer.cornerRadius = 150 / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.imageView?.contentMode = .scaleAspectFill
        plusPhotoButton.imageView?.clipsToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 2
        
        plusPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
}
