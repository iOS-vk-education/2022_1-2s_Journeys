//
//  Route.swift
//  Journeys
//
//  Created by Сергей Адольевич on 21.11.2022.
//

import Foundation
import UIKit

struct Route {
    
    let id: String
    var departureTown: Location
    var places: [Place]
    
    internal init(id: String, departureTown: Location, places: [Place]) {
        self.id = id
        self.departureTown = departureTown
        self.places = places
    }
    
    init(dictionary: [String: Any]) {
        id = dictionary[CodingKeys.id.rawValue] as? String ?? ""
        departureTown = dictionary[CodingKeys.departureTown.rawValue] as? Location ?? Location()
        places = dictionary[CodingKeys.places.rawValue] as? [Place] ?? []
    }
    
    enum CodingKeys: String {
        case id
        case departureTown
        case places
    }
}
