//
//  Adress.swift
//  Journeys
//
//  Created by Сергей Адольевич on 26.12.2022.
//

import Foundation
import FirebaseFirestore

struct Address {
    var id: String
    let coordinates: GeoPoint
    
    internal init(id: String? , coordinates: GeoPoint) {
        self.id = id ?? UUID().uuidString
        self.coordinates = coordinates
    }
    
    init?(withDictionary dict: [String: Any], id: String) {
        guard
            let coordinates = dict["coordinates"] as? GeoPoint
        else {
            return nil
        }
        
        self.id = id
        self.coordinates = coordinates
    }
    func dict() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[CodingKeys.coordinates.rawValue] = coordinates
        return dictionary
    }
}
enum CodingKeys: String {
    case coordinates
}
