//
//  Trip.swift
//  Journeys
//
//  Created by Сергей Адольевич on 21.11.2022.
//

import Foundation
import UIKit

enum TripsType {
    case saved
    case all
}

struct Trip {
    
    let id: String?
    var routeId: String
    var baggageId: String
    var isInfavourites: Bool
    var dateChanged: Date
    
    internal init(id: String?,
                  routeId: String,
                  baggageId: String,
                  dateChanged: Date,
                  isInfavourites: Bool = false) {
        self.id = id
        self.routeId = routeId
        self.baggageId = baggageId
        self.dateChanged = dateChanged
        self.isInfavourites = isInfavourites
    }
    
    init?(from dictionary: [String: Any], id: String) {
        guard
        let routeId = dictionary[CodingKeys.routeId.rawValue] as? String,
        let baggageId = dictionary[CodingKeys.baggageId.rawValue] as? String,
        let dateChanged = dictionary[CodingKeys.dateChanged.rawValue] as? String,
        let isInfavourites = dictionary[CodingKeys.isInfavourites.rawValue] as? Bool
        else {
            return nil
        }
        
        self.id = id
        self.routeId = routeId
        self.baggageId = baggageId
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        guard let date = dateFormatter.date(from: dateChanged) else { return nil }
        self.dateChanged = date
        self.isInfavourites = isInfavourites
    }
    
    init(tripWithOtherData: TripWithRouteAndImage) {
        self.id = tripWithOtherData.id
        self.routeId = tripWithOtherData.routeId
        self.baggageId = tripWithOtherData.baggageId
        self.dateChanged = tripWithOtherData.dateChanged
        self.isInfavourites = tripWithOtherData.isInfavourites
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[CodingKeys.routeId.rawValue] = routeId
        dictionary[CodingKeys.baggageId.rawValue] = baggageId
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        dictionary[CodingKeys.dateChanged.rawValue] = dateFormatter.string(from: dateChanged)
        
        dictionary[CodingKeys.isInfavourites.rawValue] = isInfavourites
        return dictionary
    }
    
    enum CodingKeys: String {
        case routeId = "route_id"
        case baggageId = "baggage_id"
        case dateChanged = "last_change"
        case isInfavourites = "is_saved"
    }
}

struct TripWithRouteAndImage {
    let id: String?
    var imageURLString: String?
    var image: UIImage?
    var route: Route
    var routeId: String
    var baggageId: String
    var isInfavourites: Bool
    var dateChanged: Date
    
    
    internal init(id: String?,
                  imageURLString: String?,
                  image: UIImage,
                  route: Route,
                  routeId: String,
                  baggageId: String,
                  dateChanged: Date,
                  isInfavourites: Bool) {
        self.id = id
        self.imageURLString = imageURLString
        self.image = image
        self.route = route
        self.routeId = routeId
        self.baggageId = baggageId
        self.dateChanged = dateChanged
        self.isInfavourites = isInfavourites
    }
    
    init(trip: Trip, route: Route, image: UIImage? = nil) {
        self.id = trip.id
        self.imageURLString = route.imageURLString
        self.image = image
        self.route = route
        self.routeId = trip.routeId
        self.baggageId = trip.baggageId
        self.dateChanged = trip.dateChanged
        self.isInfavourites = trip.isInfavourites
    }
}

extension TripWithRouteAndImage: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
        && lhs.routeId == rhs.routeId
        && lhs.baggageId == rhs.baggageId
        && lhs.imageURLString == rhs.imageURLString
    }
}
