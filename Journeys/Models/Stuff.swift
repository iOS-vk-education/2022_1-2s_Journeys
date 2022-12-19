//
//  Stuff.swift
//  Journeys
//
//  Created by Сергей Адольевич on 21.11.2022.
//

import Foundation
import UIKit

struct Stuff: Dictionariable {
    
    let id: String?
    var emoji: String?
    var name: String?
    var isPacked: Bool
    
    init(isPacked: Bool) {
        self.id = nil
        self.emoji = nil
        self.name = nil
        self.isPacked = isPacked
    }
    
    internal init(id: String, emoji: String, name: String, isPacked: Bool) {
        self.id = id
        self.emoji = emoji
        self.name = name
        self.isPacked = isPacked
    }
    
    init(from dictionary: [String: Any]) {
        id = dictionary[CodingKeys.id.rawValue] as? String ?? ""
        emoji = dictionary[CodingKeys.emoji.rawValue] as? String ?? ""
        name = dictionary[CodingKeys.name.rawValue] as? String ?? ""
        isPacked = dictionary[CodingKeys.isPacked.rawValue] as? Bool ?? false
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[CodingKeys.id.rawValue] = id
        dictionary[CodingKeys.emoji.rawValue] = emoji
        dictionary[CodingKeys.name.rawValue] = name
        dictionary[CodingKeys.isPacked.rawValue] = isPacked
        return dictionary
    }
    
    enum CodingKeys: String {
        case id
        case emoji
        case name
        case isPacked = "is_packed"
    }
}
