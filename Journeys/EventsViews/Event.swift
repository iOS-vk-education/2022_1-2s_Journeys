//
//  Event.swift
//  Journeys
//
//  Created by Сергей Адольевич on 26.12.2022.
//

import Foundation

enum EventType: String {
    case usual
    case unusual
}

struct Event {
    let id: String
    var adress: String
    var date: String
    var type: String
    var name: String
    var link: String
    var photoURL: String
    var floor: String
    var room: String
    
    internal init(id: String,
                  adress: String,
                  date: String,
                  type: String,
                  name: String,
                  link: String,
                  floor: String,
                  room: String,
                  photoURL: String) {
        self.id = id
        self.adress = adress
        self.date = date
        self.type = type
        self.name = name
        self.room = room
        self.floor = floor
        self.link = link
        self.photoURL = photoURL
    }
    
    init?(from dictionary: [String: Any], id: String) {
        guard
            let adress = dictionary[CodingKeys.adress.rawValue] as? String,
            let date = dictionary[CodingKeys.date.rawValue] as? String,
            let type = dictionary[CodingKeys.type.rawValue] as? String,
            let name = dictionary[CodingKeys.name.rawValue] as? String,
            let link = dictionary[CodingKeys.link.rawValue] as? String,
            let floor = dictionary[CodingKeys.floor.rawValue] as? String,
            let room = dictionary[CodingKeys.room.rawValue] as? String,
            let photoURL = dictionary[CodingKeys.photoURL.rawValue] as? String
        else {
            return nil
        }
        
        self.id = id
        self.adress = adress
        self.date = date
        self.type = type
        self.name = name
        self.link = link
        self.photoURL = photoURL
        self.floor = floor
        self.room = room
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[CodingKeys.id.rawValue] = id
        dictionary[CodingKeys.adress.rawValue] = adress
        dictionary[CodingKeys.date.rawValue] = date
        dictionary[CodingKeys.type.rawValue] = type
        dictionary[CodingKeys.name.rawValue] = name
        dictionary[CodingKeys.link.rawValue] = link
        dictionary[CodingKeys.photoURL.rawValue] = photoURL
        dictionary[CodingKeys.room.rawValue] = room
        dictionary[CodingKeys.floor.rawValue] = floor
        
        return dictionary
    }
    
    enum CodingKeys: String {
        case id
        case adress
        case date
        case type
        case name
        case link
        case photoURL
        case room
        case floor
    }
}
