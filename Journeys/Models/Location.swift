//
//  Location.swift
//  Journeys
//
//  Created by Сергей Адольевич on 10.12.2022.
//

import Foundation

struct Location: Dictionariable {
    var id: String
    var country: String
    var city: String
    
    internal init(id: String, country: String, city: String) {
        self.id = id
        self.country = country
        self.city = city
    }
    
    init(from dictionary: [String: Any]) {
        id = dictionary[CodingKeys.id.rawValue] as? String ?? ""
        country = dictionary[CodingKeys.country.rawValue] as? String ?? ""
        city = dictionary[CodingKeys.city.rawValue] as? String ?? ""
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[CodingKeys.id.rawValue] = id
        dictionary[CodingKeys.country.rawValue] = country
        dictionary[CodingKeys.city.rawValue] = city
        return dictionary
    }
    
    enum CodingKeys: String {
        case id
        case country
        case city
    }
}
