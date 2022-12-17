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
    func obtainRouteDataFromSever(with identifier: String) -> Route?
    func obtainTripImageFromServer(for imageURLString: String) -> UIImage?
}

// MARK: - TripsInteractorOutput

protocol TripsInteractorOutput: AnyObject {
    func didRecieveError(error: Errors)
    func didFetchTripsData(data: [Trip])
//    func didFetchData(data: DataModel)
}
