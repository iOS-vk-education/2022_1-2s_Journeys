//
//  Dictionariable.swift
//  Journeys
//
//  Created by Сергей Адольевич on 04.12.2022.
//

import Foundation

protocol Dictionariable {
    init(from dictionary: [String: Any])
    func toDictionary() -> [String: Any]
}
