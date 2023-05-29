//
//  FavoritesEvent.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 28.05.2023.
//

import Foundation

struct FavoritesEvent {
    var id: String
    
    internal init(id: String?) {
        self.id = id ?? UUID().uuidString
    }
    
    init?(withDictionary dict: [String: Any]) {
        guard
            let id = dict[CodingKeys.id.rawValue] as? String
        else {
            return nil
        }
        self.id = id
    }
    func dict() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[CodingKeys.id.rawValue] = id
        return dictionary
    }
    
    enum CodingKeys: String {
        case id
    }
}
