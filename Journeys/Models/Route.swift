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
    var imageURLString: String?
    var departureLocation: Location
    var places: [Place]
    
    internal init(id: String?,
                  imageURLString: String?,
                  departureLocation: Location,
                  places: [Place]) {
        self.id = id
        self.imageURLString = imageURLString
        self.departureLocation = departureLocation
        self.places = places
    }
    
    init?(from dictionary: [String: Any], id: String) {
        guard
            let imageURLString = dictionary[CodingKeys.imageURLString.rawValue] as? String,
            let locationDict = dictionary[CodingKeys.departureLocation.rawValue] as? [String : Any],
            let placesDict = dictionary[CodingKeys.places.rawValue] as? [[String : Any]] else {
            return nil
        }
        
        guard 
            let departureLocation = Location(from: locationDict) else {
            return nil
        }
        self.id = id
        self.imageURLString = imageURLString
        self.departureLocation = departureLocation
        self.places = placesDict.compactMap  { Place(from: $0) }
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[CodingKeys.id.rawValue] = id
        dictionary[CodingKeys.imageURLString.rawValue] = imageURLString ?? ""
        dictionary[CodingKeys.departureLocation.rawValue] = departureLocation.toDictionary()
        var  placesDict = places.compactMap  { $0.toDictionary() }
        dictionary[CodingKeys.places.rawValue] = placesDict
        return dictionary
    }
    
    enum CodingKeys: String {
        case id
        case imageURLString = "image_URL"
        case departureLocation = "departure_location"
        case places
    }
}

//struct RouteWithGeoDataPlaces {
//    var route: Route
//    var placesWithGeoData: [PlaceWithGeoData]
//    
//    init(route: Route, placesWithGeoData: [PlaceWithGeoData]) {
//        self.route = route
//        self.placesWithGeoData = placesWithGeoData
//    }
//}
