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
    let location: Location
    
    internal init(date: String, weatherCode: Int, temperatureMax: Float, temperatureMin: Float, location: Location) {
        self.date = date
        self.weatherCode = weatherCode
        self.temperatureMax = temperatureMax
        self.temperatureMin = temperatureMin
        self.location = location
    }
}
