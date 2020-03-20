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
    
    private var scrollView : UIScrollView!
    private var pageControl : UIPageControl!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureScrollView()
        
        
        
    }
    
    private func configureScrollView() {
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 150))
        scrollView.contentSize = CGSize(width: self.view.frame.size.width * 3, height: self.view.frame.size.height - 150)
        scrollView.delegate = self
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .lightGray
        view.addSubview(scrollView)
        
        pageControl = UIPageControl(frame: CGRect(x: 0, y: self.view.frame.size.height - 150, width: self.view.frame.width, height: 30))
        pageControl.numberOfPages = 3
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .white
        view.addSubview(pageControl)
    
    }
    


    
}

//MARK: - Scrollview delegate

extension WeatherController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
}



//MARK: - API

extension WeatherController {
    
    // example
            
    //        downloadHourlyForecastWeather { (array) in
    //            for data in array {
    //                print(data.temp)
    //            }
    //        }
            
    //        downloadWeeklyForecast { (array) in
    //            for data in array {
    //                print(data.date)
    //            }
    //        }
    
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
    
    func downloadWeeklyForecast(completion : @escaping(_ weatherFOorecast : [WeeklyWeatherForecast]) -> Void) {
        let KHWEEKLYFORECAT_URL = "https://api.weatherbit.io/v2.0/forecast/daily?city=Nicosia,CY&days=7&key=3f9863d5e4fc40e893eb9bc2dda7857a"
        
        var forecastArray: [WeeklyWeatherForecast] = []
        
        AF.request(KHWEEKLYFORECAT_URL).responseJSON { (requrest) in
            
            switch requrest.result {
            case . success :
                
                guard let data = requrest.data else {return}
                let decorder : JSONDecoder = JSONDecoder()
                
                guard let weekly : WeeklyData = try? decorder.decode(WeeklyData.self, from: data) else {return}
                
                forecastArray = weekly.data
                forecastArray.remove(at: 0) // remnove currentDate
                completion(forecastArray)
                
            case .failure(let error) :
                completion(forecastArray)
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
        
        
    }
    
    
    
    
}
