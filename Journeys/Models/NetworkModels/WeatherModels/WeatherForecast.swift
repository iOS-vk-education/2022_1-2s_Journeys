//
//  WeatherForecast.swift
//  ArchitecureDemo
//
//  Created by Yury Bogdanov on 26.03.2022.
//

import Foundation

struct WeatherForecast: Decodable {
    let weatherMain: [WeatherMain]
    
    
    enum CodingKeys: String, CodingKey {
        case weatherMain = "list"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        weatherMain = try values.decode([WeatherMain].self, forKey: .weatherMain)
    }
}
