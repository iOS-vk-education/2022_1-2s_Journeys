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
    var startDate: Date
    var finishDate: Date
    var type: String
    var name: String
    var link: String
    var photoURL: String
    var floor: String
    var room: String
    var description: String
    
    internal init(id: String,
                  adress: String,
                  startDate: Date,
                  finishDate: Date,
                  type: String,
                  name: String,
                  link: String,
                  floor: String,
                  room: String,
                  photoURL: String,
                  description: String) {
        self.id = id
        self.adress = adress
        self.startDate = startDate
        self.finishDate = finishDate
        self.type = type
        self.name = name
        self.room = room
        self.floor = floor
        self.link = link
        self.photoURL = photoURL
        self.description = description
    }
    
    init?(dictionary: [String: Any], id: String) {
        guard
            let adress = dictionary[CodingKeys.adress.rawValue] as? String,
            let startDate = dictionary[CodingKeys.startDate.rawValue] as? Date,
            let finishDate = dictionary[CodingKeys.finishDate.rawValue] as? Date,
            let type = dictionary[CodingKeys.type.rawValue] as? String,
            let name = dictionary[CodingKeys.name.rawValue] as? String,
            let link = dictionary[CodingKeys.link.rawValue] as? String,
            let floor = dictionary[CodingKeys.floor.rawValue] as? String,
            let room = dictionary[CodingKeys.room.rawValue] as? String,
            let photoURL = dictionary[CodingKeys.photoURL.rawValue] as? String,
            let description = dictionary[CodingKeys.description.rawValue] as? String
        else {
            return nil
        }
        
        self.id = id
        self.adress = adress
        self.startDate = startDate
        self.finishDate = finishDate
        self.type = type
        self.name = name
        self.link = link
        self.photoURL = photoURL
        self.floor = floor
        self.room = room
        self.description = description
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[CodingKeys.id.rawValue] = id
        dictionary[CodingKeys.adress.rawValue] = adress
        dictionary[CodingKeys.startDate.rawValue] = startDate
        dictionary[CodingKeys.finishDate.rawValue] = finishDate
        dictionary[CodingKeys.type.rawValue] = type
        dictionary[CodingKeys.name.rawValue] = name
        dictionary[CodingKeys.link.rawValue] = link
        dictionary[CodingKeys.photoURL.rawValue] = photoURL
        dictionary[CodingKeys.room.rawValue] = room
        dictionary[CodingKeys.floor.rawValue] = floor
        dictionary[CodingKeys.description.rawValue] = description
        
        return dictionary
    }
    
    enum CodingKeys: String {
        case id
        case adress
        case startDate
        case finishDate
        case type
        case name
        case link
        case photoURL
        case room
        case floor
        case description
    }
}

struct CreateEventsData {
    var adress: String
    var startDate: Date
    var finishDate: Date
    var type: String
    var name: String
    var link: String
    var photoURL: String
    var floor: String
    var room: String
    var description: String
    
    func dict() -> [String: Any] {
        return [
            "adress": adress,
            "startDate": startDate,
            "finishDate": finishDate,
            "type": type,
            "name": name,
            "link": link,
            "photoURL": photoURL,
            "floor": floor,
            "room": room,
            "description": description,
        ]
    }
}
