//
//  Weather.swift
//  Clima
//
//  Created by Manuel Alejandro Verdugo Pérez on 09/04/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL =  "https://api.openweathermap.org/data/2.5/weather?appid=467f59475c9a0dc9f19daaac31d88f73&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        
        // print(urlString)
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: Double, longitude: Double) {
         let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        // print("Performrequest")
        // 1 - crear URL
        if let url = URL(string: urlString){
            
            // 2 - crear URLSession
            let session = URLSession(configuration: .default)
            
            // 3 - dar a esa sesion una tarea
            let task = session.dataTask(with: url) { (data, response, error) in
                // print(data, response, error)
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    
                    // let dataString = String(data: safeData, encoding: .utf8)
                    if let safeWeather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: safeWeather)
                    }
                    
                    //  print(dataString)
                }
                
            }
            
            // 4 - Empezar la tarea
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        // WeatherData.self = tipo de dato WeatherData
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            return weather
            // print(weatherModel.temperature, weatherModel.temperatureOneDecimal)
            
            //getConditionName(weatherId: id)
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
