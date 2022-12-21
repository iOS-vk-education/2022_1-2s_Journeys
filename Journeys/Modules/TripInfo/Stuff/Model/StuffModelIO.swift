//
//  StuffModelInput.swift
//  Journeys
//
//  Created by Сергей Адольевич on 19.12.2022.
//

import Foundation

protocol StuffModelInput: AnyObject {
    func obtainStuffData()
}

protocol StuffModelOutput: AnyObject {
    func stuffWasObtainedData(data: [Stuff])
}
