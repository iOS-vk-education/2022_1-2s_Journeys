//
//  Weather.swift
//  Journeys
//
//  Created by Сергей Адольевич on 21.11.2022.
//

import Foundation

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
}

struct WeatherWithLocation: Decodable {
    let location: Location
    let weather: [Weather]
    
    internal init(location: Location, weather: [Weather]?) {
        self.location = location
        self.weather = weather ?? []
    }
    
    func isMatchToPlace(_ place: Place) -> Bool {
        guard let lastWeatherdate = weather.last?.date else { return false }
        return place.location == location
        && DateFormatter.fullDateWithDash.string(from: place.arrive) == weather.first?.date
        && DateFormatter.fullDateWithDash.string(from: place.depart) >= lastWeatherdate
    }
}
