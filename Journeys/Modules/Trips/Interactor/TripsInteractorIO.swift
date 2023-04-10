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
    func obtainTripsDataFromSever(type: TripsType)
    func obtainTripImageFromServer(withURL imageURLString: String,
                                   completion: @escaping (Result <UIImage, Error>)-> Void)
    func loadImage(for route: Route, completion: @escaping (UIImage) -> Void)
    
    func storeTripData(trip: Trip, completion: @escaping () -> Void)
    
    func deleteTrip(_ trip: Trip)
}

// MARK: - TripsInteractorOutput

protocol TripsInteractorOutput: AnyObject {
    func didRecieveError(error: Errors)
    func didFetchTripsData(trips: [TripWithRouteAndImage])
    func noTripsFetched()
    func didDeleteTrip()
}
