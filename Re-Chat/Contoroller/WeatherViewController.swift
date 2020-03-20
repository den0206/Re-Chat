//
//  WheatherViewController.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/20.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController : UIViewController {
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    //MARK: - parts
    
    private lazy var searchTextField : UITextField = {
        return makeTextField(withPlaceholder: "Search", isSecureType: false)
    }()
    
    private let dismissButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.setDimension(width: 20, height: 20)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
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
        iv.image = UIImage(systemName: "rays")
        iv.tintColor = .darkGray
        return iv
    }()
    
    private let templatureLabel : UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.font = UIFont.boldSystemFont(ofSize: 50)
        return label
    }()
    
    private let citLabel : UILabel = {
         let label = UILabel()
         label.text = "Loading..."
         label.font = UIFont.systemFont(ofSize: 35)
         return label
     }()
    
    private let updateLocationButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "retweet"), for: .normal)
        button.setDimension(width: 65, height: 65)
        button.tintColor = .black
        button.addTarget(self, action: #selector(locationPressed(_ :)), for: .touchUpInside)
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configureUI()
        
        showPresentLoadindView(true)
        
        configureLocationManager()
        
        weatherManager.delegate = self
      
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        
        view.backgroundColor = .lightGray
        
        view.addSubview(dismissButton)
        dismissButton.anchor(top : view.safeAreaLayoutGuide.topAnchor,  left : view.leftAnchor,paddongTop: 16, paddingLeft: 8)
        
        view.addSubview(searchTextField)
        searchTextField.centerY(inView: dismissButton)
        
        searchTextField.anchor(left:
            dismissButton.rightAnchor, paddingLeft: 16)
        searchTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        searchTextField.delegate = self
        
        
        let separatorVIew = UIView()
        separatorVIew.backgroundColor = .white
        searchTextField.addSubview(separatorVIew)
        separatorVIew.anchor(left : searchTextField.leftAnchor, bottom: searchTextField.bottomAnchor, right: searchTextField.rightAnchor, height: 0.75)
        
        
        view.addSubview(searchButton)
        searchButton.centerY(inView: searchTextField)
        searchButton.anchor(left : searchTextField.rightAnchor, right: view.rightAnchor, paddingLeft: 8, paddingRight: 8)
        
        view.addSubview(conditionImageview)
        conditionImageview.anchor(top : searchTextField.bottomAnchor, right: view.rightAnchor, paddongTop: 16, paddingRight: 16)
        
        view.addSubview(templatureLabel)
        templatureLabel.anchor(top: conditionImageview.bottomAnchor, right: view.rightAnchor, paddongTop: 16, paddingRight: 16)
        
        view.addSubview(citLabel)
        citLabel.anchor(top : templatureLabel.bottomAnchor, right: view.rightAnchor, paddongTop: 16, paddingRight: 16)
        
        view.addSubview(updateLocationButton)
        updateLocationButton.anchor(top : citLabel.bottomAnchor, right: view.rightAnchor, paddongTop: 16, paddingLeft: 16)
        
  
        
        
    }
    
    private func configureLocationManager() {
        
        enableLocationSearvice()
        locationManager.requestLocation()
        
    }
    
    private func enableLocationSearvice() {
        
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted , .denied:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways:
            print("Always")
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
        @unknown default:
            break
        }
    }
    
    //MARK: - Actions
    
    @objc func pressedSearch(_ sender : UIButton) {
        
        searchTextField.endEditing(true)
    }
    
    @objc func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
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
        
        guard let searchText = searchTextField.text else {return}
        
        guard searchText != "" , !searchText.isEmpty else {
            showAlert(title: "Error", message: "書き込みください")
            return
        }
        
        weatherManager.fetchWeather(cityName: searchText)

        
        searchTextField.text = ""
    }
    
}

//MARK: - LocationManger Delegate
extension WeatherViewController : CLLocationManagerDelegate {
    
    @objc func locationPressed(_ sender : UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            weatherManager.fetchWeather(latitude: lat, longtude: lon)
        } else {
            showPresentLoadindView(false)
            
            showAlert(title: "Error", message: "居場所がわかりません")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showAlert(title: "Location Error", message: error.localizedDescription)
    }
   
}

//MARK: - WeatherManager Delegate

extension WeatherViewController : WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.templatureLabel.text = weather.tempratureStrig
            self.conditionImageview.image = UIImage(systemName: weather.conditionName)
            self.citLabel.text = weather.cityName
            
            self.showPresentLoadindView(false)
        }
    }
    
    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            
            self.showPresentLoadindView(false)
            self.showAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
    
}
