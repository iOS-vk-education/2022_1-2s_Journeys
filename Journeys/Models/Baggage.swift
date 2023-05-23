//
//  Baggage.swift
//  Journeys
//
//  Created by Сергей Адольевич on 04.12.2022.
//

import Foundation


struct Baggage{
    let id: String
    var stuffIDs: [String]
    
    internal init(id: String? , stuffIDs: [String]) {
        self.id = id ?? UUID().uuidString
        self.stuffIDs = stuffIDs
    }
    
    init?(from dictionary: [String: Any], id: String) {
        guard let stuffIDs = dictionary[CodingKeys.stuffIDs.rawValue] as? [String] else { return nil }
        self.stuffIDs = stuffIDs
        self.id = id
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[CodingKeys.id.rawValue] = id
        dictionary[CodingKeys.stuffIDs.rawValue] = stuffIDs
        
        return dictionary
    }
    
    enum CodingKeys: String {
        case id
        case stuffIDs
    }
}
