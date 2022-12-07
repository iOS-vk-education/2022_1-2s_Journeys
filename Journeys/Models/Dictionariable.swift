//
//  Dictionariable.swift
//  Journeys
//
//  Created by Сергей Адольевич on 04.12.2022.
//

import Foundation

protocol DictionariableProtocol: AnyObject {
    init(from dictionary: [String: Any])
    func toDictionary() -> [String: Any]
}
