//
//  Baggage.swift
//  Journeys
//
//  Created by Сергей Адольевич on 04.12.2022.
//

import Foundation


struct Baggage {
    let id: String
    var baseStuff: [Stuff]
    var userStuff: [Stuff]
    
    internal init(id: String, baseStuff: [Stuff], userStuff: [Stuff]) {
        self.id = id
        self.baseStuff = baseStuff
        self.userStuff = userStuff
    }
    
    init(from dictionary: [String: Any]) {
        id = dictionary[CodingKeys.id.rawValue] as? String ?? ""
        baseStuff = dictionary[CodingKeys.baseStuff.rawValue] as? [Stuff] ?? []
        userStuff = dictionary[CodingKeys.userStuff.rawValue] as? [Stuff] ?? []
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[CodingKeys.id.rawValue] = id

        var baseStuffDictList: [[String: Any]] = [[:]]
        for stuff in baseStuff {
            baseStuffDictList.append(stuff.toDictionary())
        }
        dictionary[CodingKeys.baseStuff.rawValue] = baseStuffDictList
        
        var userStuffDictList: [[String: Any]] = [[:]]
        for stuff in userStuff {
            baseStuffDictList.append(stuff.toDictionary())
        }
        dictionary[CodingKeys.userStuff.rawValue] = userStuffDictList
        return dictionary
    }
    
    enum CodingKeys: String {
        case id
        case baseStuff = "base_stuff"
        case userStuff = "user_stuff"
    }
}
