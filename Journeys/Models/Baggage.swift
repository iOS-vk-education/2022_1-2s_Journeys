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
    var addedStuffListsIDs: [String]
    
    internal init(id: String? , stuffIDs: [String], addedStuffListsIDs: [String] = []) {
        self.id = id ?? UUID().uuidString
        self.stuffIDs = stuffIDs
        self.addedStuffListsIDs = addedStuffListsIDs
    }
    
    init?(from dictionary: [String: Any], id: String) {
        guard let stuffIDs = dictionary[CodingKeys.stuffIDs.rawValue] as? [String],
              let addedStuffListsIDs = dictionary[CodingKeys.addedStuffListsIDs.rawValue] as? [String]
        else { return nil }
        self.stuffIDs = stuffIDs
        self.id = id
        self.addedStuffListsIDs = addedStuffListsIDs
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[CodingKeys.id.rawValue] = id
        dictionary[CodingKeys.stuffIDs.rawValue] = stuffIDs
        dictionary[CodingKeys.addedStuffListsIDs.rawValue] = addedStuffListsIDs
        
        return dictionary
    }
    
    enum CodingKeys: String {
        case id
        case stuffIDs
        case addedStuffListsIDs = "added_stuff_listsIDs"
    }
}
