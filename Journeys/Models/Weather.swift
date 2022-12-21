//
//  Weather.swift
//  Journeys
//
//  Created by Сергей Адольевич on 21.11.2022.
//

import Foundation

enum WeatherFeature: String {
    case cloudy
    case sunny
    case rainy
    case stormy
    case snowy
    case fog
}

struct Weather: Decodable {
    let date: String
    let weatherCode: Int
    let temperatureMax: Float
    let temperatureMin: Float
    
    internal init(date: String, weatherCode: Int, temperatureMax: Float, temperatureMin: Float) {
        self.date = date
        self.weatherCode = weatherCode
        self.temperatureMax = temperatureMax
        self.temperatureMin = temperatureMin
    }
//
//    static func weatherFromForecast(from weatherForecast: WeatherForecast) {
//        
//    }
}
