//
//  WeatherData.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/20.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation

struct WeatherData : Codable {
    let name : String
    let main : Main
    let weather : [weather]
}

struct Main : Codable {
    let temp : Double
}

struct weather : Codable {
    let description : String
    let id : Int
}
