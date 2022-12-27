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
    func obtainSavedTripsDataFromServer()
    func obtainRouteDataFromSever(with identifier: String,
                                  completion: @escaping (Result <Route, Error>) -> Void)
    func obtainTripImageFromServer(withURL imageURLString: String,
                                   completion: @escaping (Result <UIImage, Error>) -> Void)
    
    func storeTripData(trip: Trip, completion: @escaping () -> Void)
    
    func deleteTrip(_ trip: Trip)
}

// MARK: - TripsInteractorOutput

protocol TripsInteractorOutput: AnyObject {
    func didRecieveError(error: Errors)
    func didFetchTripsData(data: [Trip])
    func didDeleteTrip()
//    func didFetchData(data: DataModel)
}
