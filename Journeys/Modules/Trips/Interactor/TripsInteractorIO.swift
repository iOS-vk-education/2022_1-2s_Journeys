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
    func obtainTripsDataFromSever()
    func obtainRouteDataFromSever(with identifyer: String) -> Route? 
    func obtainLocationDataFromSever(with identifyer: String) -> Location?
    func obtainTripImageFromServer(for trip: Trip) -> UIImage?
}

// MARK: - TripsInteractorOutput

protocol TripsInteractorOutput: AnyObject {
    func didRecieveError(error: Errors)
    func didFetchTripsData(data: [Trip])
//    func didFetchData(data: DataModel)
}
