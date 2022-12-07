//
//  TripsInteractor.swift
//  Journeys
//
//  Created by Nastya Ischenko on 03/11/2022.
//

import Foundation
import UIKit
import FirebaseFirestore

// MARK: - TripsInteractor

final class TripsInteractor {

    weak var output: TripsInteractorOutput?
}

extension TripsInteractor: TripsInteractorInput {
    
    func obtainTripsDataFromSever() -> [Trip] {
        var trips: [Trip] = []
        
        FirebaseManager.shared.obtainTrips() { result in
            switch result {
            case .success(let snapshot):
                for document in snapshot.documents {
                    let trip = Trip(from: document.data())
                    trips.append(trip)
                }
            case .failure(let error):
                assertionFailure("Error while obtaining trips data from server: \(error.localizedDescription)")
            }
        }
        return trips
    }
    
    func obtainRouteDataFromSever(with identifyer: String) -> Route? {
        var route: Route? = nil
        FirebaseManager.shared.obtainRoute(with: identifyer) { result in
            switch result {
            case .success(let data):
                route = Route(from: data)
            case .failure(let error):
                assertionFailure("Error while obtaining route data from server: \(error.localizedDescription)")
            }
        }
        return route
    }
    
    
    func obtainLocationDataFromSever(with identifyer: String) -> Location? {
        var location: Location? = nil
        FirebaseManager.shared.obtainLocation(with: identifyer) { result in
            switch result {
            case .success(let data):
                location = Location(from: data)
            case .failure(let error):
                assertionFailure("Error while obtaining location data from server: \(error.localizedDescription)")
            }
        }
        return location
    }
    
    func obtainTripImageFromServer(for trip: Trip) -> UIImage? {
        var resultImage: UIImage? = nil
        
        FirebaseManager.shared.obtainTripImage(trip: trip) { imageResult in
            switch imageResult {
            case .success(let image):
                resultImage = image
            case .failure(let error):
                assertionFailure("Error while obtaining trips image from server: \(error.localizedDescription)")
            }
        }
        return resultImage
    }
}
