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
    var icon: String
    var name: String
    var isbyed: Bool?
    var isPacked: Bool
    
    internal init(id: String, icon: String, name: String, isbyed: Bool? = nil, isPacked: Bool) {
        self.id = id
        self.icon = icon
        self.name = name
        self.isbyed = isbyed
        self.isPacked = isPacked
    }
    
    init(dictionary: [String: Any]) {
        id = dictionary[CodingKeys.id.rawValue] as? String ?? ""
        icon = dictionary[CodingKeys.icon.rawValue] as? String ?? ""
        name = dictionary[CodingKeys.name.rawValue] as? String ?? ""
        isbyed = dictionary[CodingKeys.isbyed.rawValue] as? Bool
        isPacked = dictionary[CodingKeys.isPacked.rawValue] as? Bool ?? false
    }
    
    enum CodingKeys: String {
        case id
        case icon
        case name
        case isbyed
        case isPacked
    }
}
