//
//  CurrentWeather.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/18.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation
import Alamofire
//import SwiftyJSON

// nest 0
struct WheatherData : Codable {
    let data : [CurrentWeather]
    
    init() {
        self.data = []
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

// nest 1

struct CurrentWeather : Codable {
    let city : String
    let timeStamp : Date
    let weather : Weather

    let currentTemp : Double
    let feelLike : Double
    let pres : Double
    let humidity : Double
    let windSpeed : Double
    let visibility : Double
    let uv : Double
    let sunrise : String
    let sunset : String

    private enum CodingKeys : String, CodingKey  {
        case city = "city_name"
        case timeStamp = "ts"
        case weather
        case currentTemp = "temp"
        case feelLike = "app_temp"
        case pres
        case humidity = "rh"
        case windSpeed = "wind_spd"
        case visibility = "vis"
        case uv
        case sunrise
        case sunset

    }

}


// nest 2

struct Weather : Codable {
    let description : String
    let icon :String
}


