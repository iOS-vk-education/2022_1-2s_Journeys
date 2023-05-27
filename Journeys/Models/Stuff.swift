//
//  Stuff.swift
//  Journeys
//
//  Created by Сергей Адольевич on 21.11.2022.
//

import Foundation
import UIKit

struct Stuff {
    
    let id: String?
    var emoji: String?
    var name: String?
    var isPacked: Bool
    
    internal init(id: String? = nil, emoji: String? = nil, name: String? = nil, isPacked: Bool) {
        self.id = id
        self.emoji = emoji
        self.name = name
        self.isPacked = isPacked
    }
    
    init?(from dictionary: [String: Any], id: String) {
        guard
        let name = dictionary[CodingKeys.name.rawValue] as? String,
        let isPacked = dictionary[CodingKeys.isPacked.rawValue] as? Bool
        else {
            return nil
        }
        self.id = id
        self.emoji = dictionary[CodingKeys.emoji.rawValue] as? String
        self.name = name
        self.isPacked = isPacked
    }
    
    init(baseStuff: BaseStuff) {
        self.id = baseStuff.id
        self.emoji = baseStuff.emoji
        self.name = baseStuff.name
        self.isPacked = false
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

extension Stuff: Equatable {
    static func == (lhs: Stuff, rhs: Stuff) -> Bool {
        lhs.id == rhs.id && lhs.emoji == rhs.emoji && lhs.name == rhs.name
    }
}

struct BaseStuff {
    var id: String
    var emoji: String
    var name: String
    
    internal init(id: String, emoji: String, name: String) {
        self.id = id
        self.emoji = emoji
        self.name = name
    }
    
    init?(from dictionary: [String: Any], id: String) {
        guard
        let emoji = dictionary[CodingKeys.emoji.rawValue] as? String,
        let name = dictionary[CodingKeys.name.rawValue] as? String
        else {
            return nil
        }
        self.id = id
        self.emoji = emoji
        self.name = name
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[CodingKeys.emoji.rawValue] = emoji
        dictionary[CodingKeys.name.rawValue] = name
        return dictionary
    }
    
    enum CodingKeys: String {
        case id
        case emoji
        case name
    }
}
