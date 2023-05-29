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
    func addSnapshotListener(type: TripsType, moduleInput: TripsModuleInput)
    func obtainTripsDataFromSever(type: TripsType)
    func obtainTripImageFromServer(withURL imageURLString: String,
                                   completion: @escaping (Result <UIImage, Error>)-> Void)
    func obtainRouteDataFromServer(for trip: Trip, completion: @escaping (TripWithRouteAndImage) -> Void)
    func loadImage(for route: Route, completion: @escaping (UIImage) -> Void)
    
    func storeTripData(trip: Trip, completion: @escaping () -> Void)
    
    func deleteTrip(_ trip: TripWithRouteAndImage)
}

// MARK: - TripsInteractorOutput

protocol TripsInteractorOutput: AnyObject {
    func didRecieveError(error: Errors)
    func didFetchTripsData(trips: [TripWithRouteAndImage])
    func noTripsFetched()
    func didDeleteTrip()
}
