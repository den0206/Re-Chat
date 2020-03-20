//
//  WeatherManager.swift
//  Re-Chat
//
//  Created by 酒井ゆうき on 2020/03/20.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate : class{
    
    func didUpdateWeather(_ weatherManager : WeatherManager, weather : WeatherModel)
    func didFailWithError(error : Error)
}

struct WeatherManager {
    
    var delegate : WeatherManagerDelegate?
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=144ec1efd75e77f2571c1521035dbe49&units=metric"
    
    func fetchWeather(cityName : String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude : CLLocationDegrees, longtude :CLLocationDegrees ) {
        
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longtude)"
        performRequest(with: urlString)
    }
    
    //MARK: - NSURLSession
    
    func performRequest(with urlString : String) {
        
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " ") else {return}
        
        print(url)
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                // pass via delegate
                self.delegate?.didFailWithError(error: error!)
                return
            }
            
            guard let safedata = data else {return}
            //parse To JSON
            if let weather = self.parseJSON(safedata) {
                print("THISSS")
                self.delegate?.didUpdateWeather(self, weather: weather)
            }
   
        }
        
        task.resume()
    }
    
   
    
    // parse
    
    func parseJSON(_ weatherData : Data) -> WeatherModel?{
        
        let decorder = JSONDecoder()

        do {
            let decorderData = try decorder.decode(WeatherData.self, from: weatherData)
            let id = decorderData.weather[0].id
            let temp = decorderData.main.temp
            let name = decorderData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temprature: temp)
            
            print(weather)
            return weather
            
        } catch {
            print(error)
            return nil
        }
        
    }
    
}
