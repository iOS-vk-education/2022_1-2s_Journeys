//
//  Place.swift
//  Journeys
//
//  Created by Сергей Адольевич on 21.11.2022.
//

import Foundation

struct Place {
    
    var location: Location
    var arrive: Date
    var depart: Date
    
    internal init(location: Location, arrive: Date, depart: Date) {
        self.location = location
        self.arrive = arrive
        self.depart = depart
    }
    
    init?(from dictionary: [String: Any]) {
        guard
            let locationDict = dictionary[CodingKeys.location.rawValue]  as? [String : Any],
            let arrive = dictionary[CodingKeys.arrive.rawValue] as? String,
            let depart = dictionary[CodingKeys.depart.rawValue] as? String else {
            return nil
            
        }
       
        guard
            let location = Location(from: locationDict) else {
            return nil
        }
        self.location = location
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        guard let arriveDate = dateFormatter.date(from: arrive) else { return nil }
        self.arrive = arriveDate
        guard let departDate = dateFormatter.date(from: depart) else { return nil }
        self.depart = departDate
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[CodingKeys.location.rawValue] = location.toDictionary()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        dictionary[CodingKeys.arrive.rawValue] = dateFormatter.string(from: arrive)
        dictionary[CodingKeys.depart.rawValue] = dateFormatter.string(from: depart)
        return dictionary
    }
    
    enum CodingKeys: String {
        case location
        case arrive
        case depart
    }
}
