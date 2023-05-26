//
//  PlaceNotification.swift
//  Journeys
//
//  Created by Сергей Адольевич on 26.05.2023.
//

import Foundation

struct PlaceNotification {
    var id: String?
    var date: Date
    var contentTitle: String
    var contentBody: String
    
    internal init(id: String?,
                  date: Date,
                  placeForContent: Place,
                  contentTitle: String = "У вас запланирована поездка") {
        self.id = id
        self.date = date
        self.contentTitle = contentTitle
        self.contentBody = "Завтра Вы отпрвляетесь в \(placeForContent.location.toString())"
        if let daysCount: Int = Calendar.daysBetween(start: placeForContent.arrive,
                                                     end: placeForContent.depart) {
            self.contentBody.append(" на \(daysCount) дней")
        }
        
    }
    
    init?(from dictionary: [String: Any]) {
        guard
            let id = dictionary[CodingKeys.id.rawValue]  as? String,
            let dateString = dictionary[CodingKeys.date.rawValue] as? String,
            let contentTitle = dictionary[CodingKeys.contentTitle.rawValue] as? String,
            let contentBody = dictionary[CodingKeys.contentBody.rawValue] as? String else {
            return nil
            
        }
        
        self.id = id
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        guard let date = dateFormatter.date(from: dateString) else { return nil }
        self.date = date
        
        self.contentTitle = contentTitle
        self.contentBody = contentBody
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[CodingKeys.id.rawValue] = id

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        dictionary[CodingKeys.date.rawValue] = dateFormatter.string(from: date)
        
        dictionary[CodingKeys.contentTitle.rawValue] = contentTitle
        dictionary[CodingKeys.contentBody.rawValue] = contentBody
        
        return dictionary
    }
    
    enum CodingKeys: String {
        case id
        case date
        case contentTitle = "content_title"
        case contentBody = "content_body"
    }
}

extension PlaceNotification: Equatable {
    static func == (lhs: PlaceNotification, rhs: PlaceNotification) -> Bool {
        lhs.date == rhs.date && lhs.contentTitle == rhs.contentTitle && lhs.contentBody == rhs.contentBody
    }
}
