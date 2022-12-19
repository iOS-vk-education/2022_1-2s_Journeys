//
//  Route.swift
//  Journeys
//
//  Created by Сергей Адольевич on 21.11.2022.
//

import Foundation
import UIKit

struct Route: Dictionariable {
    
    let id: String
    var departureLocation: Location
    var places: [Place]
    
    internal init(id: String, departureLocation: Location, places: [Place]) {
        self.id = id
        self.departureLocation = departureLocation
        self.places = places
    }
    
    init(from dictionary: [String: Any]) {
        id = dictionary[CodingKeys.id.rawValue] as? String ?? ""
        departureLocation = dictionary[CodingKeys.departureLocation.rawValue] as? Location ?? Location()
        places = dictionary[CodingKeys.places.rawValue] as? [Place] ?? []
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[CodingKeys.id.rawValue] = id
        dictionary[CodingKeys.departureLocation.rawValue] = departureLocation
        var placesDictList: [[String: Any]] = [[:]]
        for place in places {
            placesDictList.append(place.toDictionary())
        }
        dictionary[CodingKeys.places.rawValue] = placesDictList
        return dictionary
    }
    
    enum CodingKeys: String {
        case id
        case departureLocation = "departure_location"
        case places
    }
}
