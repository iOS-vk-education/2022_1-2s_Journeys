//
//  TripsInteractorIO.swift
//  Journeys
//
//  Created by Nastya Ischenko on 03/11/2022.
//

import Foundation
import UIKit

// MARK: - Trips InteractorInput

protocol TripsInteractorInput: AnyObject {
    func obtainTripsDataFromSever() -> [Trip]
    func tripDisplayData(trip: Trip) -> TripCell.DisplayData
    func obtainRouteDataFromSever(with identifyer: String) -> Route? 
    func obtainLocationDataFromSever(with identifyer: String) -> Location?
    func obtainTripImageFromServer(for trip: Trip) -> UIImage?
}

// MARK: - TripsInteractorOutput

protocol TripsInteractorOutput: AnyObject {
}
