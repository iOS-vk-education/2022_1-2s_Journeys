//
//  Stuff.swift
//  Journeys
//
//  Created by Сергей Адольевич on 21.11.2022.
//

import Foundation
import UIKit

struct Stuff {
    
    let id: String
    var emoji: String
    var name: String
    var isbyed: Bool?
    var isPacked: Bool
    
    internal init(id: String, emoji: String, name: String, isbyed: Bool? = nil, isPacked: Bool) {
        self.id = id
        self.emoji = emoji
        self.name = name
        self.isbyed = isbyed
        self.isPacked = isPacked
    }
    
    init(from dictionary: [String: Any]) {
        id = dictionary[CodingKeys.id.rawValue] as? String ?? ""
        emoji = dictionary[CodingKeys.emoji.rawValue] as? String ?? ""
        name = dictionary[CodingKeys.name.rawValue] as? String ?? ""
        isbyed = dictionary[CodingKeys.isbyed.rawValue] as? Bool
        isPacked = dictionary[CodingKeys.isPacked.rawValue] as? Bool ?? false
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[CodingKeys.id.rawValue] = id
        dictionary[CodingKeys.emoji.rawValue] = emoji
        dictionary[CodingKeys.name.rawValue] = name
        dictionary[CodingKeys.isbyed.rawValue] = isbyed
        dictionary[CodingKeys.isPacked.rawValue] = isPacked
        return dictionary
    }
    
    enum CodingKeys: String {
        case id
        case emoji
        case name
        case isbyed = "is_packed"
        case isPacked = "is_byed"
    }
}
