//
//  Place.swift
//  Journeys
//
//  Created by Сергей Адольевич on 21.11.2022.
//

import Foundation

struct Location {
    var id: String
    var country: String
    var city: String
    
    internal init(id: String, country: String, city: String) {
        self.id = id
        self.country = country
        self.city = city
    }
    
    init(from dictionary: [String: Any]) {
        id = dictionary[CodingKeys.id.rawValue] as? String ?? ""
        country = dictionary[CodingKeys.country.rawValue] as? String ?? ""
        city = dictionary[CodingKeys.city.rawValue] as? String ?? ""
    }
    
    enum CodingKeys: String {
        case id
        case country
        case city
    }
}

struct Place {
    
    var locationId: String
    var arrive: Date
    var depart: Date
    
    internal init(locationId: String, arrive: Date, depart: Date) {
        self.locationId = locationId
        self.arrive = arrive
        self.depart = depart
    }
    
    init(from dictionary: [String: Any]) {
        locationId = dictionary[CodingKeys.locationId.rawValue] as? String ?? ""
        arrive = dictionary[CodingKeys.arrive.rawValue] as? Date ?? Date()
        depart = dictionary[CodingKeys.depart.rawValue] as? Date ?? Date()
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[CodingKeys.locationId.rawValue] = locationId
        dictionary[CodingKeys.arrive.rawValue] = arrive
        dictionary[CodingKeys.depart.rawValue] = depart
        return dictionary
    }
    
    enum CodingKeys: String {
        case locationId = "location_id"
        case arrive
        case depart
    }
}
