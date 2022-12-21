//
//  WeatherMain.swift
//  ArchitecureDemo
//
//  Created by Yury Bogdanov on 26.03.2022.
//

import Foundation

struct WeatherTemp: Decodable {
    let main: Double
}

struct WeatherMain: Decodable {
    let temperature: WeatherTemp
    let data: [WeatherData]
    
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case data = "weather"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        temperature = try values.decode(WeatherTemp.self, forKey: .temperature)
        data = try values.decode([WeatherData].self, forKey: .data)
    }
}
