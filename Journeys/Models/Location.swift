//
//  Location.swift
//  Journeys
//
//  Created by Сергей Адольевич on 10.12.2022.
//

import Foundation

struct Location: Dictionariable {
    var country: String
    var city: String
    
    
    init () {
        self.country = ""
        self.city = ""
    }
    
    internal init(country: String, city: String) {
        self.country = country
        self.city = city
    }
    
    init(from dictionary: [String: Any]) {
        country = dictionary[CodingKeys.country.rawValue] as? String ?? ""
        city = dictionary[CodingKeys.city.rawValue] as? String ?? ""
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[CodingKeys.country.rawValue] = country
        dictionary[CodingKeys.city.rawValue] = city
        return dictionary
    }
    
    enum CodingKeys: String {
        case country
        case city
    }
}
