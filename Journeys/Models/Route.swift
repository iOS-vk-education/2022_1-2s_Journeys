//
//  Route.swift
//  Journeys
//
//  Created by Сергей Адольевич on 21.11.2022.
//

import Foundation
import UIKit

struct Route {
    
    let id: String?
    var departureLocation: Location
    var places: [Place]
    
    internal init(id: String?, departureLocation: Location, places: [Place]) {
        self.id = id
        self.departureLocation = departureLocation
        self.places = places
    }
    
    init?(from dictionary: [String: Any], id: String) {
        guard
            let locationDict = dictionary[CodingKeys.departureLocation.rawValue] as? [String : Any],
            let placesDict = dictionary[CodingKeys.places.rawValue] as? [[String : Any]] else {
            return nil
        }
        
        guard 
            let departureLocation = Location(from: locationDict) else {
            return nil
        }
        self.id = id
        self.departureLocation = departureLocation
        self.places = placesDict.compactMap  { Place(from: $0) }
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[CodingKeys.id.rawValue] = id
        dictionary[CodingKeys.departureLocation.rawValue] = departureLocation.toDictionary()
        var  placesDict = places.compactMap  { $0.toDictionary() }
        dictionary[CodingKeys.places.rawValue] = placesDict
        return dictionary
    }
    
    enum CodingKeys: String {
        case id
        case departureLocation = "departure_location"
        case places
    }
}
