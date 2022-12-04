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
    
    init() {
        self.id = ""
        self.country = ""
        self.city = ""
    }
    
    internal init(id: String, country: String, city: String) {
        self.id = id
        self.country = country
        self.city = city
    }
    
    init(dictionary: [String: Any]) {
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
    
    let id: String
    var location: Location
    var arrive: Date
    var depart: Date
    var weather: [Weather]?
    
    internal init(id: String, location: Location, arrive: Date, depart: Date, weather: [Weather]? = nil) {
        self.id = id
        self.location = location
        self.arrive = arrive
        self.depart = depart
        self.weather = weather
    }
    
    init(dictionary: [String: Any]) {
        let id = dictionary[CodingKeys.id.rawValue] as? String ?? ""
        let location = dictionary[CodingKeys.location.rawValue] as? Location ?? Location(id: "", country: "", city: "")
        let arrive = dictionary[CodingKeys.arrive.rawValue] as? Date ?? Date()
        let depart = dictionary[CodingKeys.depart.rawValue] as? Date ?? Date()
        self.init(id: id, location: location, arrive: arrive, depart: depart)
    }
    
    enum CodingKeys: String {
        case id
        case location
        case arrive
        case depart
        case weather
    }
}
