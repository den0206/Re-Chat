//
//  WeatherController.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/18.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import Alamofire

class WeatherController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        
        getCurrentWeather()
    }
    
    func getCurrentWeather() {

        let KLOCATIONAPI_URL = "https://api.weatherbit.io/v2.0/current?city=Raleigh,NC&key=3f9863d5e4fc40e893eb9bc2dda7857a"
        
        
        
        AF.request(KLOCATIONAPI_URL).responseJSON { (response) in
            guard let data = response.data else {return}
            let decorder : JSONDecoder = JSONDecoder()
            
            do {
                let weather : WheatherData = try decorder.decode(WheatherData.self, from: data)
                
                print(weather.data[0].city)
                
            } catch {
                print(error)
            }
            
        }
        
        
    }
}
