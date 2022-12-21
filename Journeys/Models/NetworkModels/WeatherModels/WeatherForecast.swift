//
//  WeatherForecast.swift
//  ArchitecureDemo
//
//  Created by Yury Bogdanov on 26.03.2022.
//

import Foundation

struct WeatherForecast: Decodable {
    let dailyWeather: WeatherMain
    
    
    enum CodingKeys: String, CodingKey {
        case dailyWeather = "daily"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        dailyWeather = try values.decode(WeatherMain.self, forKey: .dailyWeather)
    }
}
