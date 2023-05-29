//
//  Favorites.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 28.05.2023.
//

import Foundation

struct Favorites {
    var isLiked: [String]
    
    init?(withDictionary dict: [String: Any]) {
        guard
            let isLiked = dict[CodingKeys.isLiked.rawValue] as? [String]
        else {
            return nil
        }
        self.isLiked = isLiked
    }
    func dict() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[CodingKeys.isLiked.rawValue] = isLiked
        return dictionary
    }
    
    enum CodingKeys: String {
        case isLiked
    }
}
