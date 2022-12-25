//
//  StuffModelInput.swift
//  Journeys
//
//  Created by Сергей Адольевич on 19.12.2022.
//

import Foundation

protocol StuffModelInput: AnyObject {
    func obtainStuffData(baggageId: String)
    func deleteStuff(baggage: Baggage, stuffId: String)
    func obtainBaggageData(baggageId: String) 
}

protocol StuffModelOutput: AnyObject {
    func didRecieveStuffData(data: [Stuff])
    func didRecieveBaggageData(data: Baggage)
    func didRecieveError(_ type: Errors)
    func didDeleteStuff()
}
