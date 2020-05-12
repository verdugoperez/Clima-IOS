//
//  WeatherData.swift
//  Clima
//
//  Created by Manuel Alejandro Verdugo Pérez on 09/04/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable /*Decodable, Encodable*/ {
    let name: String
    let weather: [Weather]
    let main: Main
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main: Codable {
    let temp: Double
//    "feels_like": 27.49,
//    "temp_min": 29,
//    "temp_max": 30,
//    "pressure": 1014,
//    "humidity": 39
}
