//
//  HoulrForecast.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/18.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation
import Alamofire

struct HourlyDate : Codable {
    let data : [HourlyForecast]
    
    
}

struct HourlyForecast : Codable {
    
    let date : Date
    let temp : Double
    let weather : Weather
    
    private enum CodingKeys : String, CodingKey {
        case date = "ts"
        case temp = "temp"
        case weather
    }
    
//    
//
//    
//    func downloadDailyForecastWeather() {
//        
//        let KHOULYFORECAT_URL = "https://api.weatherbit.io/v2.0/forecast/hourly?city=Nicosia,CY&hours=24&key=3f9863d5e4fc40e893eb9bc2dda7857a"
//        
//        AF.request(KHOULYFORECAT_URL).responseJSON { (response) in
//            
////            guard let data = response.data else {return}
////            let decorder : JSONDecoder = JSONDecoder()
////
////            do {
////
////            } catch {
////                print("NO Forecast")
////            }
//            
//            switch response.result {
//            case .success(_):
//                print(response.result)
//                
//            case .failure(let error) :
//                print(error)
//            }
//            
//        }
//        
//        
//        
//        
//    }
    
}
