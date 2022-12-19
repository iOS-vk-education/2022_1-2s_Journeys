//
//  Place.swift
//  Journeys
//
//  Created by Сергей Адольевич on 21.11.2022.
//

import Foundation

struct Place: Dictionariable {
    
    var location: Location
    var arrive: Date
    var depart: Date
    
    internal init(location: Location, arrive: Date, depart: Date) {
        self.location = location
        self.arrive = arrive
        self.depart = depart
    }
    
    init(from dictionary: [String: Any]) {
        location = dictionary[CodingKeys.location.rawValue] as? Location ?? Location()
        arrive = dictionary[CodingKeys.arrive.rawValue] as? Date ?? Date()
        depart = dictionary[CodingKeys.depart.rawValue] as? Date ?? Date()
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[CodingKeys.location.rawValue] = location
        dictionary[CodingKeys.arrive.rawValue] = arrive
        dictionary[CodingKeys.depart.rawValue] = depart
        return dictionary
    }
    
    enum CodingKeys: String {
        case location
        case arrive
        case depart
    }
}
