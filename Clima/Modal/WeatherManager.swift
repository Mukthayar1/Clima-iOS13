//
//  WeatherManager.swift
//  Clima
//
//  Created by Muhammad Mukhtayar on 30/09/2024.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=f16244fab54a1b6250ba738d91b92929&units=metric";
    
    func fetchWeather (cityName:String){
        let urlString = "\(weatherUrl)&q=\(cityName)";
        perfomRequest(urlString: urlString)
    }
    
    func perfomRequest(urlString: String) {
        // 1 CREATE URL
        if let url = URL(string: urlString) {
            
            // 2 CREATE URL SESSION
            let session = URLSession(configuration: .default)
            
            // 3 GIVE SESSION TASK
            let task = session.dataTask(with: url) { (data, response, error) in
                self.weatherApiHandle(data: data, response: response, error: error)
            }
            
            // 4 START THE TASK
            task.resume()
        }
    }

    func weatherApiHandle(data: Data?, response: URLResponse?, error: Error?) {
        
        if error != nil {
            print(error!)
            return
        }
        
        if let safeData = data {
            let dataString = String(data: safeData, encoding: .utf8)
            print(dataString!)
        }
        
    }
}
