//
//  Event.swift
//  Journeys
//
//  Created by Сергей Адольевич on 26.12.2022.
//

import Foundation
import UIKit

struct Event {
    var address: String
    var startDate: String
    var finishDate: String
    var type: String
    var name: String
    var link: String
    var photoURL: String
    var floor: String
    var room: String
    var description: String
    var isLiked: Bool
    var userID: String
    
    internal init(address: String,
                  startDate: String,
                  finishDate: String,
                  type: String,
                  name: String,
                  link: String,
                  photoURL: String,
                  floor: String,
                  room: String,
                  description: String,
                  isLiked: Bool,
                  userID: String) {
        self.address = address
        self.startDate = startDate
        self.finishDate = finishDate
        self.type = type
        self.name = name
        self.room = room
        self.floor = floor
        self.link = link
        self.photoURL = photoURL
        self.description = description
        self.isLiked = isLiked
        self.userID = userID
    }
    
    init?(dictionary: [String: Any], userID: String) {
        guard
            let address = dictionary[CodingKeys.address.rawValue] as? String,
            let startDate = dictionary[CodingKeys.startDate.rawValue] as? String,
            let finishDate = dictionary[CodingKeys.finishDate.rawValue] as? String,
            let type = dictionary[CodingKeys.type.rawValue] as? String,
            let name = dictionary[CodingKeys.name.rawValue] as? String,
            let link = dictionary[CodingKeys.link.rawValue] as? String,
            let floor = dictionary[CodingKeys.floor.rawValue] as? String,
            let room = dictionary[CodingKeys.room.rawValue] as? String,
            let photoURL = dictionary[CodingKeys.photoURL.rawValue] as? String,
            let description = dictionary[CodingKeys.description.rawValue] as? String,
            let isLiked = dictionary[CodingKeys.isLiked.rawValue] as? Bool
        else {
            return nil
        }
        self.address = address
        self.userID = userID
        self.startDate = startDate
        self.finishDate = finishDate
        self.type = type
        self.name = name
        self.link = link
        self.photoURL = photoURL
        self.floor = floor
        self.room = room
        self.description = description
        self.isLiked = isLiked
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[CodingKeys.address.rawValue] = address
        dictionary[CodingKeys.startDate.rawValue] = startDate
        dictionary[CodingKeys.finishDate.rawValue] = finishDate
        dictionary[CodingKeys.type.rawValue] = type
        dictionary[CodingKeys.name.rawValue] = name
        dictionary[CodingKeys.link.rawValue] = link
        dictionary[CodingKeys.photoURL.rawValue] = photoURL
        dictionary[CodingKeys.room.rawValue] = room
        dictionary[CodingKeys.floor.rawValue] = floor
        dictionary[CodingKeys.description.rawValue] = description
        dictionary[CodingKeys.isLiked.rawValue] = isLiked
        dictionary[CodingKeys.userID.rawValue] = userID
        
        return dictionary
    }
    
    enum CodingKeys: String {
        case address
        case startDate
        case finishDate
        case type
        case name
        case link
        case photoURL
        case room
        case floor
        case description
        case isLiked
        case userID
    }
}

struct EventViewObject {
    var address: String
    var startDate: String
    var finishDate: String
    var type: String
    var name: String
    var link: String
    var photoURL: String
    var image: UIImage?
    var floor: String
    var room: String
    var description: String
    var isLiked: Bool
    var userID: String
    
    internal init(address: String,
                  startDate: String,
                  finishDate: String,
                  type: String,
                  name: String,
                  link: String,
                  image: UIImage,
                  photoURL: String,
                  floor: String,
                  room: String,
                  description: String,
                  isLiked: Bool,
                  userID: String) {
        self.address = address
        self.startDate = startDate
        self.finishDate = finishDate
        self.type = type
        self.image = image
        self.name = name
        self.room = room
        self.floor = floor
        self.link = link
        self.photoURL = photoURL
        self.description = description
        self.isLiked = isLiked
        self.userID = userID
    }

}
