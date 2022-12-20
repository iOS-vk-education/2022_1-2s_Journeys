//
//  Weather.swift
//  Journeys
//
//  Created by Сергей Адольевич on 21.11.2022.
//

import Foundation

enum WeatherFeature: Codable {
    case cloudy
    case sunny
    case rainy
    case stormy
}

struct Weather: Codable {
    let id: String
    var date: Date
    var temperature: Int
    var weatherFeature: WeatherFeature
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case temperature
        case weatherFeature = "weather_feature"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        date = try values.decode(Date.self, forKey: .date)
        temperature = try values.decode(Int.self, forKey: .temperature)
        weatherFeature = try values.decode(WeatherFeature.self, forKey: .weatherFeature)
    }
}
