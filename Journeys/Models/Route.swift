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
    var departureLocationId: String
    var places: [Place]
    
    internal init(id: String, departureLocationId: String, places: [Place]) {
        self.id = id
        self.departureLocationId = departureLocationId
        self.places = places
    }
    
    init(from dictionary: [String: Any]) {
        id = dictionary[CodingKeys.id.rawValue] as? String ?? ""
        departureLocationId = dictionary[CodingKeys.departureTownLocationId.rawValue] as? String ?? ""
        places = dictionary[CodingKeys.places.rawValue] as? [Place] ?? []
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[CodingKeys.id.rawValue] = id
        dictionary[CodingKeys.departureTownLocationId.rawValue] = departureLocationId
        var placesDictList: [[String: Any]] = [[:]]
        for place in places {
            placesDictList.append(place.toDictionary())
        }
        dictionary[CodingKeys.places.rawValue] = placesDictList
        return dictionary
    }
    
    enum CodingKeys: String {
        case id
        case departureTownLocationId = "departure_town_location_id"
        case places
    }
}
