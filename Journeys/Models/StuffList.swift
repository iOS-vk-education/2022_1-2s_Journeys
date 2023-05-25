//
//  StuffList.swift
//  Journeys
//
//  Created by Сергей Адольевич on 07.05.2023.
//

import Foundation
import UIKit

enum StuffListType {
    case all
    case alwaysAdding
}

struct StuffList {
    let id: String?
    var color: ColorForFB
    var name: String
    var stuffIDs: [String]
    var autoAddToAllTrips: Bool
    var dateCreated: Date
    
    internal init(id: String?,
                  color: ColorForFB,
                  name: String,
                  stuffIDs: [String],
                  autoAddToAllTrips: Bool,
                  dateCreated: Date) {
        self.id = id
        self.color = color
        self.name = name
        self.stuffIDs = stuffIDs
        self.autoAddToAllTrips = autoAddToAllTrips
        self.dateCreated = dateCreated
    }
    
    init?(from dictionary: [String: Any], id: String) {
        guard
            let name = dictionary[CodingKeys.name.rawValue] as? String,
            let colorDict = dictionary[CodingKeys.color.rawValue] as? [String : Any],
            let stuffIDs = dictionary[CodingKeys.stuffIDs.rawValue] as? [String],
            let autoAddToAllTrips = dictionary[CodingKeys.autoAddToAllTrips.rawValue] as? Bool,
            let dateCreatedString = dictionary[CodingKeys.dateCreated.rawValue] as? String
        else {
            return nil
        }
        
        guard
            let color = ColorForFB(from: colorDict) else {
            return nil
        }
        self.id = id
        self.name = name
        self.color = color
        self.stuffIDs = stuffIDs
        self.autoAddToAllTrips = autoAddToAllTrips
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        guard let dateCreated = dateFormatter.date(from: dateCreatedString) else { return nil }
        self.dateCreated = dateCreated
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[CodingKeys.id.rawValue] = id
        dictionary[CodingKeys.color.rawValue] = color.toDictionary()
        dictionary[CodingKeys.name.rawValue] = name
        dictionary[CodingKeys.stuffIDs.rawValue] = stuffIDs
        dictionary[CodingKeys.autoAddToAllTrips.rawValue] = autoAddToAllTrips
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        dictionary[CodingKeys.dateCreated.rawValue] =  dateFormatter.string(from: dateCreated)
        
        return dictionary
    }
    
    enum CodingKeys: String {
        case id
        case color
        case name
        case stuffIDs = "stuff_IDs"
        case autoAddToAllTrips = "auto_add"
        case dateCreated = "date_created"
    }
}

struct ColorForFB {
    var red: Float
    var green: Float
    var blue: Float
    var alpha: Float
    
    internal init(red: Float, green: Float, blue: Float, alpha: Float) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    init(color: UIColor) {
        red = Float(color.redValue)
        green = Float(color.greenValue)
        blue = Float(color.blueValue)
        alpha = Float(color.alphaValue)
    }
    
    init?(from dictionary: [String: Any]) {
        guard
        let red = dictionary[CodingKeys.red.rawValue] as? Float,
        let green = dictionary[CodingKeys.green.rawValue] as? Float,
        let blue = dictionary[CodingKeys.blue.rawValue] as? Float,
        let alpha = dictionary[CodingKeys.alpha.rawValue] as? Float
        else {
            return nil
        }
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[CodingKeys.red.rawValue] = red
        dictionary[CodingKeys.green.rawValue] = green
        dictionary[CodingKeys.blue.rawValue] = blue
        dictionary[CodingKeys.alpha.rawValue] = alpha
        return dictionary
    }
    
    func toUIColor() -> UIColor {
        UIColor(red: CGFloat(red),
                green: CGFloat(green),
                blue: CGFloat(blue),
                alpha: CGFloat(alpha))
    }
    
    enum CodingKeys: String {
        case red
        case green
        case blue
        case alpha
    }
}
