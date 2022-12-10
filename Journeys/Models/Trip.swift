//
//  Trip.swift
//  Journeys
//
//  Created by Сергей Адольевич on 21.11.2022.
//

import Foundation
import UIKit

struct Trip: Dictionariable {
    
    let id: String
    var imageURLString: String
    var routeId: String
    var baggageId: String?
    var isInfavourites: Bool
    
    internal init(id: String, imageURLString: String, routeId: String, baggageId: String?, isInfavourites: Bool = false) {
        self.id = id
        self.imageURLString = imageURLString
        self.routeId = routeId
        self.baggageId = baggageId
        self.isInfavourites = isInfavourites
    }
    
    init(from dictionary: [String: Any]) {
        id = dictionary[CodingKeys.id.rawValue] as? String ?? ""
        imageURLString = dictionary[CodingKeys.imageURLString.rawValue] as? String ?? ""
        routeId = dictionary[CodingKeys.routeId.rawValue] as? String ?? ""
        baggageId = dictionary[CodingKeys.baggageId.rawValue] as? String
        isInfavourites = dictionary[CodingKeys.isInfavourites.rawValue] as? Bool ?? false
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[CodingKeys.id.rawValue] = id
        dictionary[CodingKeys.imageURLString.rawValue] = imageURLString
        dictionary[CodingKeys.routeId.rawValue] = routeId
        dictionary[CodingKeys.baggageId.rawValue] = baggageId
        dictionary[CodingKeys.isInfavourites.rawValue] = isInfavourites
        return dictionary
    }
    
    enum CodingKeys: String {
        case id
        case imageURLString = "image_URL"
        case routeId = "route_id"
        case baggageId = "baggage_id"
        case isInfavourites = "is_saved"
    }
//    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decode(String.self, forKey: .id)
//        image = try container.decode(URL.self, forKey: .image)
//        route = try container.decode(Route.self, forKey: .route)
//        stuff = try container.decode([Stuff].self, forKey: .stuff)
//        isInfavourites = try container.decode(Bool.self, forKey: .isInfavourites)
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
//        try container.encode(image, forKey: .image)
//        try container.encode(route, forKey: .route)
//        try container.encode(stuff, forKey: .stuff)
//        try container.encode(isInfavourites, forKey: .isInfavourites)
//    }
}
