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



//struct WheatherDate {
//
//    private enum RootKey : String, CodingKey {
//        case data
//        case count
//    }
//
//    struct CurrentWeather {
//        var city : String?
//        var timeStamp : Date?
//        var weather : Weather?
//
//        var currentTemp : Double?
//        var feelLike : Double?
//        var pres : Double?
//        var humidity : Double?
//        var windSpeed : Double?
//        var visibility : Double?
//        var uv : Double?
//        var sunrise : String?
//        var sunset : String?
//
//
//    }
//
//    private enum CodingKeys : String, CodingKey  {
//        case city = "city_name"
//        case timeStamp = "ts"
//        case weather
//        case currentTemp = "temp"
//        case feelLike = "app_temp"
//        case pres
//        case humidity = "rh"
//        case windSpeed = "wind_spd"
//        case visibility = "vis"
//        case uv
//        case sunrise
//        case sunset
//
//    }
//
//    struct Weather : Codable {
//        let description : String
//        let icon :String
//    }
//
//    var currentWeather : [CurrentWeather]?
//    var totalCount : Int = 0
//}
//
//extension WheatherDate : Decodable{
//
//    init(from decoder : Decoder) throws {
//        self.currentWeather = []
//        let root = try decoder.container(keyedBy: RootKey.self)
//        var items = try root.nestedUnkeyedContainer(forKey: .data)
//
//        while !items.isAtEnd {
//            let container = try items.nestedContainer(keyedBy: CodingKeys.self)
//
//            var item = CurrentWeather()
//            item.city = try container.decode(String.self, forKey: .city)
////            item.timeStamp = try container.d
//
//
//            self.currentWeather?.append(item)
//        }
//        totalCount = try root.decode(Int.self, forKey: .count)
//    }
//
//}

