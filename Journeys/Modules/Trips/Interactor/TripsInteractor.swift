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
    let FBService: FirebaseServiceProtocol
    
    internal init() {
        self.FBService = FirebaseService()
    }
    
}

extension TripsInteractor: TripsInteractorInput {
    
    func obtainTripsDataFromSever() {
        FBService.obtainTrips() { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let trips):
                strongSelf.output?.didFetchTripsData(data: trips)
            case .failure(let error):
                assertionFailure("Error while obtaining trips data from server: \(error.localizedDescription)")
                strongSelf.output?.didRecieveError(error: .obtainDataError)
            }
        }
    }
    
    func obtainRouteDataFromSever(with identifier: String) -> Route? {
        var route: Route?
        FBService.obtainRoute(with: identifier) { result in
            
            switch result {
            case .success(let routeResult):
                route = routeResult
            case .failure(let error):
                assertionFailure("Error while obtaining route data from server: \(error.localizedDescription)")
            }
        }
        return route
    }
    
    
    func obtainLocationDataFromSever(with identifier: String) -> Location? {
        var location: Location?
        FBService.obtainLocation(with: identifier) { result in
            switch result {
            case .success(let locationResult):
                location = locationResult
            case .failure(let error):
                assertionFailure("Error while obtaining location data from server: \(error.localizedDescription)")
            }
        }
        return location
    }
    
    func obtainTripImageFromServer(for trip: Trip) -> UIImage? {
        var resultImage: UIImage? = nil
        
        FBService.obtainTripImage(trip: trip) { imageResult in
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
