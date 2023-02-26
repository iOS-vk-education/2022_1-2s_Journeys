//
//  Adress.swift
//  Journeys
//
//  Created by Сергей Адольевич on 26.12.2022.
//

import Foundation

struct Adress {
    var latitude: Double
    var longtitude: Double
    
    internal init( latitude: Double, longtitude: Double) {
        self.latitude = latitude
        self.longtitude = longtitude
    }
    
    init?(from dictionary: [String: Any]) {
        guard
        let latitude = dictionary[CodingKeys.latitude.rawValue] as? Double,
        let longtitude = dictionary[CodingKeys.latitude.rawValue] as? Double
        else {
            return nil
        }
        self.latitude = latitude
        self.longtitude = longtitude
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[CodingKeys.latitude.rawValue] = latitude
        dictionary[CodingKeys.longtitude.rawValue] = longtitude
        return dictionary
    }
    
    enum CodingKeys: String {
        case latitude
        case longtitude
    }
}
