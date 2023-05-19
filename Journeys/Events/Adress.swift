//
//  Adress.swift
//  Journeys
//
//  Created by Сергей Адольевич on 26.12.2022.
//

import Foundation
import FirebaseFirestore

//struct Adress {
//    let id: String
//    var coordinates: GeoPoint
//    internal init(coordinates: GeoPoint, id: String) {
//        self.coordinates = coordinates
//        self.id = id
//    }
//    init?(dictionary: [String: Any], id: String) {
//        guard
//        let coordinates = dictionary[CodingKeys.coordinates.rawValue] as? GeoPoint,
//            let id = dictionary[CodingKeys.id.rawValue] as? String
//        else {
//            return nil
//        }
//        self.coordinates = coordinates
//        self.id = id
//    }
//    func toDictionary() -> [String: Any] {
//        var dictionary: [String: Any] = [:]
//        dictionary[CodingKeys.coordinates.rawValue] = coordinates
//        dictionary[CodingKeys.id.rawValue] = id
//        return dictionary
//    }
//    enum CodingKeys: String {
//        case coordinates
//        case id
//    }
//}

struct Adress {
    var id: String
    let coordinates: GeoPoint
    
    internal init(id: String? , coordinates: GeoPoint) {
        self.id = id ?? UUID().uuidString
        self.coordinates = coordinates
    }
    
    init?(dict: [String: Any], id: String) {
        guard
            let coordinates = dict["coordinates"] as? GeoPoint
        else {
            return nil
        }
        
        self.id = id
        self.coordinates = coordinates
    }
    func dict() -> [String: Any] {
        return [
            "coordinates": coordinates,
        ]
    }
}

struct CreateAdressData {
    let coordinates: GeoPoint
    
    func dict() -> [String: Any] {
        return [
            "coordinates": coordinates,
        ]
    }
}
