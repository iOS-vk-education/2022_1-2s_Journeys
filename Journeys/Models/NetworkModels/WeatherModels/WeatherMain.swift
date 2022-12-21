//
//  WeatherMain.swift
//  ArchitecureDemo
//
//  Created by Yury Bogdanov on 26.03.2022.
//

import Foundation

//0    Clear sky
//1, 2, 3    Mainly clear, partly cloudy, and overcast
//45, 48    Fog and depositing rime fog
//51, 53, 55    Drizzle: Light, moderate, and dense intensity
//56, 57    Freezing Drizzle: Light and dense intensity
//61, 63, 65    Rain: Slight, moderate and heavy intensity
//66, 67    Freezing Rain: Light and heavy intensity
//71, 73, 75    Snow fall: Slight, moderate, and heavy intensity
//77    Snow grains
//80, 81, 82    Rain showers: Slight, moderate, and violent
//85, 86    Snow showers slight and heavy
//95 *    Thunderstorm: Slight or moderate
//96, 99 *    Thunderstorm with slight and heavy hail

struct WeatherMain: Decodable {
    let date: [String]
    let weatherCode: [Int]
    let temperatureMax: [Float]
    let temperatureMin: [Float]
    
    
    enum CodingKeys: String, CodingKey {
        case date = "time"
        case weatherCode = "weathercode"
        case temperatureMax = "temperature_2m_max"
        case temperatureMin = "temperature_2m_min"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        date = try values.decode([String].self, forKey: .date)
        weatherCode = try values.decode([Int].self, forKey: .weatherCode)
        temperatureMax = try values.decode([Float].self, forKey: .temperatureMax)
        temperatureMin = try values.decode([Float].self, forKey: .temperatureMin)
    }
}
