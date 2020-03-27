//
//  WeeklyWeatherForecast.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/19.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation


struct WeeklyData : Codable {
    let data : [WeeklyWeatherForecast]
    
}

struct WeeklyWeatherForecast : Codable{
    
    let date : Date
    let temp : Double
    let weather : Weather
    
    private enum CodingKeys : String, CodingKey {
        case date = "ts"
        case temp = "temp"
        case weather
    }
    
   
    

}
