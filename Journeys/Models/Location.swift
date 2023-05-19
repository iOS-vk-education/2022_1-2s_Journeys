//
//  Location.swift
//  Journeys
//
//  Created by Сергей Адольевич on 10.12.2022.
//

import Foundation

struct Location: Decodable {
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
    
    init?(from dictionary: [String: Any]) {
        guard
            let country = dictionary[CodingKeys.country.rawValue] as? String,
            let city = dictionary[CodingKeys.city.rawValue] as? String
        else {
            return nil
        }
        self.country = country
        self.city = city
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[CodingKeys.country.rawValue] = country
        dictionary[CodingKeys.city.rawValue] = city
        return dictionary
    }
    
    func toString() -> String {
        return country + " " + city
    }
    
    enum CodingKeys: String, CodingKey {
        case country
        case city
    }
}

extension Location: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.country == rhs.country && lhs.city == rhs.city
    }
}

struct LocationsWithCurrencyRate: Decodable {
    var locations: [Location]
    var currencyRate: CurrencyRate
    
    internal init(locations: [Location], currencyRate: CurrencyRate) {
        self.locations = locations
        self.currencyRate = currencyRate
    }
}
