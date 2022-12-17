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
    
    internal init(firebaseService: FirebaseServiceProtocol) {
        self.FBService = firebaseService
    }
    
}

extension TripsInteractor: TripsInteractorInput {
    
    func obtainTripsDataFromSever() {
        guard let trips = FBService.obtainTrips() else {
            output?.didRecieveError(error: .obtainDataError)
            return
        }
        output?.didFetchTripsData(data: trips)
    }
    
    func obtainRouteDataFromSever(with identifier: String) -> Route? {
        FBService.obtainRoute(with: identifier)
    }
    
    func obtainTripImageFromServer(for imageURLString: String) -> UIImage? {
        FBService.obtainTripImage(for: imageURLString)
    }
}
