//
//  TripsInteractorIO.swift
//  Journeys
//
//  Created by Nastya Ischenko on 03/11/2022.
//

import Foundation

// MARK: - Trips InteractorInput

protocol TripsInteractorInput: AnyObject {
    func obtainDataFromSever() -> [Trip]
}

// MARK: - TripsInteractorOutput

protocol TripsInteractorOutput: AnyObject {
}
