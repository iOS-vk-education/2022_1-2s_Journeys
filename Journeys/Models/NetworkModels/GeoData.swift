//
//  Geocoding.swift
//  Journeys
//
//  Created by Сергей Адольевич on 21.12.2022.
//

import Foundation

struct GeoData: Decodable {
    let latitude: Double
    let longitude: Double
    let countryCode: String
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case countryCode = "country"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        latitude = try values.decode(Double.self, forKey: .latitude)
        longitude = try values.decode(Double.self, forKey: .longitude)
        countryCode = try values.decode(String.self, forKey: .countryCode)
    }
}

struct Coordinates {
    var latitude: Double
    var longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(from geoData: GeoData) {
        self.latitude = geoData.latitude
        self.longitude = geoData.longitude
    }
}
