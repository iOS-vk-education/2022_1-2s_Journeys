//
//  Trip.swift
//  Journeys
//
//  Created by Сергей Адольевич on 21.11.2022.
//

import Foundation
import UIKit

struct Trip {
    
    let id: String
    var imageURLString: String
    var image: UIImage?
    var route: Route
    var stuff: [Stuff]?
    var isInfavourites: Bool
    var start: Date
    var finish: Date
    
    internal init(id: String, imageURLString: String, image: UIImage? = nil, route: Route, stuff: [Stuff]? = nil, isInfavourites: Bool = false, start: Date, finish: Date) {
        self.id = id
        self.imageURLString = imageURLString
        self.route = route
        self.stuff = stuff
        self.isInfavourites = isInfavourites
        self.start = start
        self.finish = finish
    }
    
    init(dictionary: [String: Any]) {
        id = dictionary[CodingKeys.id.rawValue] as? String ?? ""
        imageURLString = dictionary[CodingKeys.imageURLString.rawValue] as? String ?? ""
        route = dictionary[CodingKeys.route.rawValue] as? Route ?? Route(id: "", departureTown: Location(), places: [])
        stuff = dictionary[CodingKeys.stuff.rawValue] as? [Stuff]
        isInfavourites = dictionary[CodingKeys.isInfavourites.rawValue] as? Bool ?? false
        start = dictionary[CodingKeys.start.rawValue] as? Date ?? Date()
        finish = dictionary[CodingKeys.finish.rawValue] as? Date ?? Date()
    }
    
    enum CodingKeys: String {
        case id
        case imageURLString
        case route
        case stuff
        case isInfavourites = "is_saved"
        case start
        case finish
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
