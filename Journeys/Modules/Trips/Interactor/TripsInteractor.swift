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
    
    func obtainRouteDataFromSever(with identifier: String, completion: @escaping (Result<Route, Error>) -> Void) {
        FBService.obtainRoute(with: identifier, completion: completion)
    }
    
    func obtainTripImageFromServer(for imageURLString: String, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        FBService.obtainTripImage(for: imageURLString, completion: completion)
    }
}
