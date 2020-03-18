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
        
        //        let current = WheatherData()
        //        current.getCurrentWeather()
        
        downloadHourlyForecastWeather { (array) in
            for data in array {
                print(data.temp)
            }
        }
    }
    
    func downloadHourlyForecastWeather(completion : @escaping(_ weatherForecats : [HourlyForecast]) -> Void) {
        
        let KHOULYFORECAT_URL = "https://api.weatherbit.io/v2.0/forecast/hourly?city=Nicosia,CY&hours=24&key=3f9863d5e4fc40e893eb9bc2dda7857a"
        
        AF.request(KHOULYFORECAT_URL).responseJSON { (response) in
            
            var forecastArray: [HourlyForecast] = []
            
            guard let data = response.data else {return}
              let decorder : JSONDecoder = JSONDecoder()
            
            
            do {
                let houly = try decorder.decode(HourlyDate.self, from: data)
                
//                print(houly.data.count)
//                for item in houly.data {
//                    forecastArray.append(item)
//
//                }
                
                forecastArray = houly.data
                completion(forecastArray)
            } catch {
                completion(forecastArray)
                print(error.localizedDescription)
            }
            
        }
        
        
            
            
        }
    
}
